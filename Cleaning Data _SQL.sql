/* Cleaning data in SQL Queries */

Select * 
From NashvilleHousing


--Standardize Date Format

Select SaleDate, Convert (Date,SaleDate)
From NashvilleHousing

Update NashvilleHousing
Set Saledate = Convert (Date,SaleDate)

Alter Table NashvilleHousing
Add saleDateconverted date; 

Update NashvilleHousing
Set SaleDateConverted = Convert (Date,SaleDate)

--Populate Proprety Address Data

Select * 
From NashvilleHousing
--Where PropertyAddress Is Null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
     ON a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
     ON a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress Is Null
--Order by ParcelID

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyADDRESS) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyADDRESS) +1, Len (PropertyAddress)) as Address
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar (255);

Update NashvilleHousing 
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyADDRESS) -1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255);

Update NashvilleHousing 
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyADDRESS) +1, Len (PropertyAddress))

Select * From NashvilleHousing

Select 
PARSENAME (Replace(OwnerAddress, ',', '.'), 3),
PARSENAME (Replace(OwnerAddress, ',', '.'), 2),
PARSENAME (Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar (255);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME (Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar (255);

Update NashvilleHousing 
SET OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar (255);

Update NashvilleHousing 
SET OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',', '.'), 1)

Select * From NashvilleHousing


--Change Y and N to No and Yes in "Sold as vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
  , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
        END
From NashvilleHousing
Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
        END

--Remove Duplicate 

WITH RowNumCTE AS(
SELECT *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
	   PropertyAddress,
	   SalePrice,
	   Saledate,
	   LegalReference
	   ORDER By
	      UniqueID
		  ) row_num
From NashvilleHousing
--Order by ParcelID
)
SELECT*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--Delete Unuset Columns

 ALTER Table NashvilleHousing
 Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

 Select * 
 From NashvilleHousing

 ALTER Table NashvilleHousing
 Drop Column SaleDate