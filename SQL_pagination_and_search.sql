create or alter procedure GetData
@pageNumber int,
@PageSize int
as
Begin
	--In SQL Server, the command SET NOCOUNT ON is used to stop the message that indicates the number of rows affected by a query
	--or stored procedure from being returned as part of the result set.
	set nocount on;
	declare @start int,@end int ;
	set @start = ((@pageNumber - 1) * @PageSize) + 1;
	set @end = (@pageNumber * @PageSize);

	with data as(
		select ROW_NUMBER() over(order by OrderId) AS SrNo,* from Orders
	)

	select * from data where SrNo between @start and @end

end
--this go statement marks the end of procedure otherwise we will get limit exceeded error
go

--Example usage 
exec GetData 4,10