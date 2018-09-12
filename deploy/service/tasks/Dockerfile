FROM ccr.ccs.tencentyun.com/develop/redis-cluster-sentine

MAINTAINER huangyunqing huangyunqing@icarbonx.com

RUN echo "Start building...."
RUN cp sentinel.conf /etc/redis/
RUN echo "End building...."
CMD /usr/local/bin/redis-sentinel /etc/redis/sentinel.conf