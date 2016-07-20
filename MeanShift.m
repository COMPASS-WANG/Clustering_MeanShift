function [IDX] = MeanShift(data,Radius)
%采用基础MeanShift算法，单位均匀核函数
%data图像二维数据
%load('Aggregation');   
StopThresh=0.1;%MeanShift迭代结束阈值
N=size(data,1);
Visited=zeros(N,1);%访问与否标记
PointChosen=1;%每次迭代初始点
CenterNumTh=zeros(N,1);
NumTh=0;%编号
IDX=zeros(N,1);
AllCenter=zeros(N,2);
Weight=[];

while 1
    WeightTemp=zeros(1,N);
	NewCenter=data(PointChosen,:);
    while 1
        PreCenter=NewCenter;
	    Dis2Cen=sqrt(sum((data-repmat(NewCenter,N,1)).^2,2));
	    PointIn=find(Dis2Cen<Radius);%寻找圈内点
		Visited(PointIn)=1;%将访问过的点值置1
	    WeightTemp(PointIn)=WeightTemp(PointIn)+1;%更新权重
		NewCenter=mean(data(PointIn,:),1);%求均值，获得新中心
	    
		if(sum((NewCenter-PreCenter).^2,2)<StopThresh)%MeanShift停止后处理模块
            RealCenter=0;
   		    for i=1:NumTh
			    if(sum((NewCenter-AllCenter(i,:)).^2,2)<Radius)
				    RealCenter=i;
			    end
            end
			if RealCenter>0%合并
		        AllCenter(RealCenter,:)=(AllCenter(RealCenter,:)+NewCenter)/2;
			    Weight(RealCenter,:)=Weight(RealCenter,:)+WeightTemp;
			else
			    NumTh=NumTh+1;%添加新中心
				Weight(NumTh,:)=WeightTemp;
				AllCenter(NumTh,:)=NewCenter;   
            end
            break;
        end
    end
    PointsNVisited=find(Visited==0);
    if(isempty(PointsNVisited))
         break;
    end;
    PointChosen=PointsNVisited(1);
end%最外侧循环
[Useless,IDX]=max(Weight,[],1);
%scatter(data(:,1),data(:,2),20,IDX,'filled');
