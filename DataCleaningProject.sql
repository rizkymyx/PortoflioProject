/*

Cleaning data in SQL Queries

*/

Select *
from PortofolioProject..NashvilleHousing

-------------

-- Standardize date format
Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortofolioProject..NashvilleHousing

update NashvilleHousing
set	SaleDate = CONVERT(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set	SaleDateConverted = CONVERT(Date,SaleDate)

-------------------

-- populate property address data
Select *
from PortofolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject..NashvilleHousing a
JOIN PortofolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------

--breaking out address into individual columns (address, city, state)
Select PropertyAddress
from PortofolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortofolioProject..NashvilleHousing



alter table PortofolioProject..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortofolioProject..NashvilleHousing
set	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table PortofolioProject..NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortofolioProject..NashvilleHousing
set	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from PortofolioProject..NashvilleHousing