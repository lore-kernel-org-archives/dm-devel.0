From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH] multipath-tools:Prioritizer based on a
 time-delay algorithm
Date: Mon, 22 May 2017 16:01:41 +0800
Message-ID: <8f78508a-a968-2208-5206-8c8a7654c4eb@huawei.com>
References: <1494215904-7564-1-git-send-email-philip.yang@huawei.com>
	<1494501243.6093.16.camel@suse.com>
	<aec35be2-fa7f-1fc8-9cd8-a52647cddc13@huawei.com>
	<1494960873.4700.13.camel@suse.com>
	<c2428d4a-7693-927d-5c57-eeebb721640b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c2428d4a-7693-927d-5c57-eeebb721640b@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zouming.zouming@huawei.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, guanjunxiong@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hello Martin and Christophe,

How about this patch?
Thanks a lot.
Best.


On 2017/5/19 16:43, Yang Feng wrote:
> Hello Martin,
> 
> Firstly, thank you very much for your comments.
> And find my replys and the up-to-date patch.
> 
> Best regards!
> 
> 
>> Please think about the name once again. Maybe you should call it
>> "io_latency" or "path_latency" instead of "delayedpath"?
> OK, as the following patch.
> 
>>
>> Hm, I can't see a lot of difference in the parsing code wrt the
>> previous version. IMO it's still non-straightforward and hard to
>> comprehend. Maybe I didn't express myself clearly enough. Here is how
>> I'd code this:
>>
>>  1. Verify that the string starts with a digit. Error if it does not.
>>  2. Parse the delay interval using strtoul().
>>  3. The "end" pointer of strtoul() points to the unit, which has to be
>> "s", "ms" or "us". Verify, and set the unit accordingly.
>>  4. Verify that the next character is '|', and that it's followed by a
>> digit.
>>  5. Parse the number with strtoul()
>>  6. Verify that there's no garbage at the end of the string. 
> Thank you , as the following patch.
> 
>>
>> Please follow the https://en.wikipedia.org/wiki/Robustness_principle.
>> If a user enters "1500ms" here, the parsing will silently fail, and
>> with it the whole prio algorithm. This will cause user confusion.
>> Please don't do this
> Thank you , as the following patch.
> 
>>
>> However please consider lowering the upper bound, I kind of doubt that
>> 1000 IOs will finish quickly. More often than not, a lot of paths will
>> appear at the same time (e.g. if a port of a storage array is enabled)
>> and we'll have to send 1000 IOs to each one.
>>
> OK, the upper bound lower to 200, as the following patch.
> 
>>> +    while (temp-- > 0)
>>> +    {
>>> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
>>> +        before = timeval_to_us(&tv);		
>>> +
>>> +        if (do_readsector0(pp->fd, timeout) == 2)
>>> +        {
>>> +            condlog(0, "%s: path down", pp->dev);
>>> +            return -1;
>>> +        }
>>> +
>>> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
>>> +        after = timeval_to_us(&tv);
>>> +
>>> +        delay = after - before;
>>> +    	
>>> +        min = (min <= delay) ? min : delay;
>>> +        max = (max >= delay) ? max : delay;
>>> +
>>> +        toldelay += delay;
>>> +    }
>>> +
>>> +    toldelay -= min + max;
>>
>> Why are you doing this? If you want to discard "extreme" values, this
>> is probably not sufficient. If cons == 3, this will have the effect to
>> use a single measurement rather than an average, is that intended?
>>
>> Btw, as you are doing statistics here anyway, you may want to calculate
>> the estimate of the standard deviation and warn the user if the
>> delay_interval is smaller than, say, 2 * standard deviation.
>>
>> Please consider printing a message with the measured value at debug
>> level 3 or higher.
> OK, as the following patch.
> 
>>>  "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
>>>  .RE
>>>  .TP 12
>>> +.I delayed
>>
>> should be "delayedpath" here?
> OK, as the following patch.
>>
>>> +Needs a value of the form
>>> +\fI"<delay_interval|cons_num>"\fR
>>> +.RS
>>> +.TP 8
>>> +.I delay_interval
>>> +The interval values of average IO-time-delay between two different
>>> neighbour ranks of path priority, used to partition different
>>> priority ranks.
>>
>> It might be good to give an example here, like this:
>>
>> "If delay_interval=10ms, the paths will be grouped in priority groups
>> with path latency 0-10ms, 10-20ms, 20-30ms, etc." 
> OK, as the following patch.>
> 
> ---
>>From 58d718fdd34550bd9c4a32c6e9a87099c1e45a9f Mon Sep 17 00:00:00 2001
> From: Yang Feng <philip.yang@huawei.com>
> Date: Fri, 19 May 2017 16:09:07 +0800
> Subject: [PATCH] libmultipath/prioritizers: Prioritizer for device mapper multipath, where the corresponding priority
> values of specific paths are provided by a latency algorithm. And the latency algorithm is dependent on the following
> arguments(latency_interval and io_num). The principle of the algorithm is illustrated as follows:
> 1. By sending a certain number "cons_num" of read IOs to the current path continuously, the IOs' average latency can be calculated.
> 2. According to the average latency of each path and the weight value "latency_interval", the priority "rc" of each path can be provided.
> 
>                    latency_interval   latency_interval   latency_interval       latency_interval
>          	 |------------------|------------------|------------------|...|------------------|
> 		 |  priority rank 1 |  priority rank 2 |  priority rank 3 |...|  priority rank x |
> 		 |------------------|------------------|------------------|...|------------------|
> 				          Priority Rank Partitioning
> ---
>  libmultipath/prioritizers/Makefile       |   6 +-
>  libmultipath/prioritizers/path_latency.c | 271 +++++++++++++++++++++++++++++++
>  multipath/multipath.conf.5               |  18 ++
>  3 files changed, 294 insertions(+), 1 deletion(-)
>  create mode 100644 libmultipath/prioritizers/path_latency.c
> 
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index 36b42e4..d2f20f6 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -18,13 +18,17 @@ LIBS = \
>  	libpriorandom.so \
>  	libpriordac.so \
>  	libprioweightedpath.so \
> -	libpriosysfs.so
> +	libpriopath_latency.so \
> +	libpriosysfs.so
> 
>  all: $(LIBS)
> 
>  libprioalua.so: alua.o alua_rtpg.o
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> 
> +libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
> +	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
> +
>  libprio%.so: %.o
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> 
> diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
> new file mode 100644
> index 0000000..a666b6c
> --- /dev/null
> +++ b/libmultipath/prioritizers/path_latency.c
> @@ -0,0 +1,271 @@
> +/*
> + * (C) Copyright HUAWEI Technology Corp. 2017, 2021   All Rights Reserved.
> + *
> + * main.c
> + *
> + * Prioritizer for device mapper multipath, where the corresponding priority
> + * values of specific paths are provided by a latency algorithm. And the
> + * latency algorithm is dependent on arguments.
> + *
> + * The principle of the algorithm as follows:
> + * 1. By sending a certain number "io_num" of read IOs to the current path
> + *    continuously, the IOs' average latency can be calculated.
> + * 2. According to the average latency of each path and the weight value
> + *    "latency_interval", the priority "rc" of each path can be provided.
> + *
> + * Author(s): Yang Feng <philip.yang@huawei.com>
> + *            Zou Ming <zouming.zouming@huawei.com>
> + *
> + * This file is released under the GPL.
> + */
> +#include <stdio.h>
> +#include <math.h>
> +#include <ctype.h>
> +#include <time.h>
> +
> +#include "debug.h"
> +#include "prio.h"
> +#include "structs.h"
> +#include "../checkers/libsg.h"
> +
> +#define THRES_USEC_VALUE        120000000LL    /*unit: us, =120s*/
> +
> +#define MAX_IO_NUM              200
> +#define MIN_IO_NUM              10
> +
> +#define MAX_LATENCY_INTERVAL    60            /*unit: s*/
> +#define MIN_LATENCY_INTERVAL    1             /*unit: us, or ms, or s*/
> +
> +#define DEFAULT_PRIORITY        0
> +
> +#define MAX_CHAR_SIZE           30
> +
> +#define CHAR_USEC               "us"
> +#define CHAR_MSEC               "ms"
> +#define CHAR_SEC                "s"
> +
> +enum interval_type {
> +    INTERVAL_USEC,
> +    INTERVAL_MSEC,
> +    INTERVAL_SEC,
> +    INTERVAL_INVALID
> +};
> +
> +/* interval_unit_str and interval_unit_type keep the same assignment sequence */
> +static const char *interval_unit_str[MAX_CHAR_SIZE] = {
> +    CHAR_USEC, CHAR_MSEC, CHAR_SEC
> +};
> +static const int interval_unit_type[] = {
> +    INTERVAL_USEC, INTERVAL_MSEC, INTERVAL_SEC
> +};
> +
> +#define USEC_PER_SEC      1000000LL
> +#define USEC_PER_MSEC     1000LL
> +#define USEC_PER_USEC     1LL
> +
> +static const int conversion_ratio[] = {
> +    [INTERVAL_USEC]		= USEC_PER_USEC,
> +    [INTERVAL_MSEC]     = USEC_PER_MSEC,
> +    [INTERVAL_SEC]		= USEC_PER_SEC,
> +    [INTERVAL_INVALID]	= 0
> +};
> +
> +static long long path_latency[MAX_IO_NUM];
> +
> +static inline long long timeval_to_us(const struct timespec *tv)
> +{
> +	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec >> 10);
> +}
> +
> +static int do_readsector0(int fd, unsigned int timeout)
> +{
> +	unsigned char buf[4096];
> +	unsigned char sbuf[SENSE_BUFF_LEN];
> +	int ret;
> +
> +	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
> +		      SENSE_BUFF_LEN, timeout);
> +
> +	return ret;
> +}
> +
> +int check_args_valid(int io_num, long long latency_interval, int type)
> +{
> +    if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
> +    {
> +        condlog(0, "args io_num is more than the valid values range");
> +        return 0;
> +    }
> +
> +    /* s:[1, 60], ms:[1, 60000], us:[1, 60000000] */
> +    if ((latency_interval < MIN_LATENCY_INTERVAL) || (latency_interval > (MAX_LATENCY_INTERVAL * USEC_PER_SEC / conversion_ratio[type])))
> +    {
> +        condlog(0, "args latency_interval is more than the valid values range");
> +        return 0;
> +    }
> +
> +    return 1;
> +}
> +
> +static int get_interval_type(char *type)
> +{
> +    int index;
> +
> +    for (index = 0; index < sizeof(interval_unit_str)/MAX_CHAR_SIZE; index++)
> +    {
> +        if (strcmp(type, interval_unit_str[index]) == 0)
> +        {
> +            return interval_unit_type[index];
> +        }
> +    }
> +
> +    return INTERVAL_INVALID;
> +}
> +
> +long long get_conversion_ratio(int type)
> +{
> +    return conversion_ratio[type];
> +}
> +
> +/* In multipath.conf, args form: io_num|latency_interval. For example,
> +*  args is "20|10ms", this function can get 20, 10.
> +*/
> +static int get_interval_and_ionum(char *args,
> +                                        int *ionum,
> +                                        long long *interval)
> +{
> +    char source[MAX_CHAR_SIZE];
> +    char vertica = '|';
> +    char *endstrbefore = NULL;
> +    char *endstrafter = NULL;
> +    int type;
> +    unsigned int size = strlen(args);
> +    long long ratio;
> +
> +    if ((args == NULL) || (ionum == NULL) || (interval == NULL))
> +    {
> +        condlog(0, "args string is NULL");
> +        return 0;
> +    }
> +
> +    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
> +    {
> +        condlog(0, "args string's size is too long");
> +        return 0;
> +    }
> +
> +    memcpy(source, args, size+1);
> +
> +    if (!isdigit(source[0]))
> +    {
> +        condlog(0, "args io_num string's first char is not digit");
> +        return 0;
> +    }
> +
> +    *ionum = (int)strtoul(source, &endstrbefore, 10);
> +    if (endstrbefore[0] != vertica)
> +    {
> +        condlog(0, "segmentation char is invalid");
> +        return 0;
> +    }
> +
> +    if (!isdigit(endstrbefore[1]))
> +    {
> +        condlog(0, "args latency_interval string's first char is not digit");
> +        return 0;
> +    }
> +
> +    *interval = (long long)strtol(&endstrbefore[1], &endstrafter, 10);
> +    type = get_interval_type(endstrafter);
> +    if (type == INTERVAL_INVALID)
> +    {
> +        condlog(0, "args latency_interval type is invalid");
> +        return 0;
> +    }
> +
> +    if (check_args_valid(*ionum, *interval, type) == 0)
> +    {
> +        return 0;
> +    }
> +
> +	ratio = get_conversion_ratio(type);
> +    *interval *= (long long)ratio;
> +
> +    return 1;
> +}
> +
> +long long calc_standard_deviation(long long *path_latency, int size, long long avglatency)
> +{
> +    int index;
> +    long long total = 0;
> +
> +    for (index = 0; index < size; index++)
> +    {
> +        total += (path_latency[index] - avglatency) * (path_latency[index] - avglatency);
> +    }
> +
> +    total /= (size-1);
> +
> +    return (long long)sqrt((double)total);
> +}
> +
> +int getprio (struct path *pp, char *args, unsigned int timeout)
> +{
> +    int rc, temp;
> +    int index = 0;
> +    int io_num;
> +    long long latency_interval;
> +    long long avglatency;
> +    long long standard_deviation;
> +    long long toldelay = 0;
> +    long long before, after;
> +    struct timespec tv;
> +
> +	if (pp->fd < 0)
> +		return -1;
> +
> +    if (get_interval_and_ionum(args, &io_num, &latency_interval) == 0)
> +    {
> +        condlog(0, "%s: get path_latency args fail", pp->dev);
> +        return DEFAULT_PRIORITY;
> +    }
> +
> +    memset(path_latency, 0, sizeof(path_latency));
> +
> +    temp = io_num;
> +    while (temp-- > 0)
> +    {
> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> +        before = timeval_to_us(&tv);		
> +
> +        if (do_readsector0(pp->fd, timeout) == 2)
> +        {
> +            condlog(0, "%s: path down", pp->dev);
> +            return -1;
> +        }
> +
> +        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> +        after = timeval_to_us(&tv);
> +
> +        path_latency[index] = after - before;
> +        toldelay += path_latency[index++];
> +    }
> +
> +    avglatency = toldelay/(long long)io_num;
> +    condlog(4, "%s: average latency is (%lld)", pp->dev, avglatency);
> +
> +    if (avglatency > THRES_USEC_VALUE)
> +    {
> +        condlog(0, "%s: average latency (%lld) is more than thresold", pp->dev, avglatency);
> +        return DEFAULT_PRIORITY;
> +    }
> +
> +    /* warn the user if the latency_interval set is smaller than (2 * standard deviation), or equal */
> +    standard_deviation = calc_standard_deviation(path_latency, index, avglatency);
> +    if (latency_interval <= (2 * standard_deviation))
> +        condlog(3, "%s: args latency_interval set is smaller than 2 * standard deviation (%lld us), or equal",
> +            pp->dev, standard_deviation);
> +
> +	rc = (int)(THRES_USEC_VALUE - (avglatency/(long long)latency_interval));
> +    return rc;
> +}
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 5939688..3dd0d77 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -293,6 +293,10 @@ Generate a random priority between 1 and 10.
>  Generate the path priority based on the regular expression and the
>  priority provided as argument. Requires prio_args keyword.
>  .TP
> +.I path_latency
> +Generate the path priority based on a latency algorithm.
> +Requires prio_args keyword.
> +.TP
>  .I datacore
>  .\" XXX
>  ???. Requires prio_args keyword.
> @@ -333,6 +337,20 @@ these values can be looked up through sysfs or by running \fImultipathd show pat
>  "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
>  .RE
>  .TP 12
> +.I path_latency
> +Needs a value of the form
> +\fI"<latency_interval>|<io_num>"\fR
> +.RS
> +.TP 8
> +.I latency_interval
> +The interval values of average latency between two different neighbour ranks of path priority, used to partition different priority ranks.
> +Form: XXs, or XXXus, or XXXms. Unit: Second, or Microsecond, or Millisecond. Valid Values: Integer, s [1, 60], ms [1, 60000], us [1, 60000000],
> +For example: If latency_interval=10ms, the paths will be grouped in priority groups with path latency 0-10ms, 10-20ms, 20-30ms, etc..
> +.TP
> +.I io_num
> +The number of read IOs sent to the current path continuously, used to calculate the average path latency. Valid Values: Integer, [10, 200].
> +.RE
> +.TP 12
>  .I alua
>  If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
>  set will always be in their own path group.
> 
