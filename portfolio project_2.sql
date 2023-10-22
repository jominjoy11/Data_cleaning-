select * from housing

--pupulate property address
select * from housing 
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b on a.ParcelID = b.parcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b on a.ParcelID = b.parcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Breaking address into different columns 
select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as city 
from housing 

--adding new columns to insert the new values
alter table housing
add Propertysplitaddress Nvarchar(255);

Update housing
set Propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table housing 
add propertysplitcity NVarchar(255);

update housing
set propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select  
PARSENAME( replace(OwnerAddress,',','.'),3 ),
PARSENAME( replace(OwnerAddress,',','.'),2 ),
PARSENAME( replace(OwnerAddress,',','.'),1 )

from housing

alter table housing
add ownersplitaddress Nvarchar(255);
alter table housing
add ownersplitcity Nvarchar(255);
alter table housing
add ownersplitstate Nvarchar(255);

Update housing
set ownersplitaddress = PARSENAME( replace(OwnerAddress,',','.'),3 )
Update housing
set ownersplitcity =PARSENAME( replace(OwnerAddress,',','.'),2 )
Update housing
set ownersplitstate =PARSENAME( replace(OwnerAddress,',','.'),1 )

select distinct(SoldAsVacant),count(SoldAsVacant)
from housing
group by SoldAsVacant
order by 2

--Removing duplicates 
with rownumCTE as (
select *,ROW_NUMBER() over(partition by ParcelID,
										PropertyAddress,
										SalePrice,
										SaleDate,
										LegalReference
										order by
											UniqueID
										) row_num
from housing 
)
delete from rownumCTE
where row_num > 1
--order by PropertyAddress

--delete unused columns

select * from housing 

alter table housing 
drop column OwnerAddress,
			TaxDistrict,
			PropertyAddress