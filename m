From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v6 1/1] multipath-tools: Prioritizer based on
	a latency algorithm
Date: Wed, 21 Jun 2017 12:22:00 +0200
Message-ID: <CABr-Gne-2UNuBnNk-_hi7ao5k9p=ELXwpABVOxmBt4V_JWxi4A@mail.gmail.com>
References: <1498038034-18276-1-git-send-email-philip.yang@huawei.com>
	<1498038034-18276-2-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4714149889952481295=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498038034-18276-2-git-send-email-philip.yang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yang Feng <philip.yang@huawei.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, tristan.ye@suse.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============4714149889952481295==
Content-Type: multipart/alternative; boundary="001a11c0060e13f18b055275bd78"

--001a11c0060e13f18b055275bd78
Content-Type: text/plain; charset="UTF-8"

This version is now merged.
Thanks.

Incremental enhancements can go from there if needed.

On Wed, Jun 21, 2017 at 11:40 AM, Yang Feng <philip.yang@huawei.com> wrote:

> libmultipath/prioritizers: Prioritizer for device mapper multipath,
> where the corresponding priority values of specific paths are provided
> by a latency algorithm on the logarithmic scale. And the latency algorithm
> is dependent on the following arguments(io_num and base_num).
> The principle of the algorithm is illustrated as follows:
> 1. By sending a certain number "io_num" of read IOs to the current
> path continuously, the IOs' average latency can be calculated.
> 2. Max average latency value is 100s, and min value is 1us. According
> to the average latency of each path and the "base_number" of logarithmic
> scale, the priority "rc" of each path can be provided.
>
> For example: If base_num=10, the paths will be grouped in priority groups
> with path latency <=1us, (1us, 10us], (10us, 100us], (100us, 1ms], (1ms,
> 10ms],
> (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s. As follows:
>
>        <=1us            (1us, 10us]      (10us, 100us]               >100s
> |------------------|------------------|------------------|..
> .|------------------|
> |  priority rank 9 |  priority rank 8 |  priority rank 7 |...|  priority
> rank 0 |
> |------------------|------------------|------------------|..
> .|------------------|
>                            Priority Rank Partitioning
>
> Signed-off-by: Yang Feng <philip.yang@huawei.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/prio.h                      |   1 +
>  libmultipath/prioritizers/Makefile       |   4 +
>  libmultipath/prioritizers/path_latency.c | 257
> +++++++++++++++++++++++++++++++
>  multipath/multipath.conf.5               |  20 +++
>  4 files changed, 282 insertions(+)
>  create mode 100644 libmultipath/prioritizers/path_latency.c
>
> diff --git a/libmultipath/prio.h b/libmultipath/prio.h
> index 0193c52..c97fe39 100644
> --- a/libmultipath/prio.h
> +++ b/libmultipath/prio.h
> @@ -29,6 +29,7 @@ struct path;
>  #define PRIO_RDAC              "rdac"
>  #define PRIO_WEIGHTED_PATH     "weightedpath"
>  #define PRIO_SYSFS             "sysfs"
> +#define PRIO_PATH_LATENCY      "path_latency"
>
>  /*
>   * Value used to mark the fact prio was not defined
> diff --git a/libmultipath/prioritizers/Makefile
> b/libmultipath/prioritizers/Makefile
> index 36b42e4..ca47cdf 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -18,6 +18,7 @@ LIBS = \
>         libpriorandom.so \
>         libpriordac.so \
>         libprioweightedpath.so \
> +       libpriopath_latency.so \
>         libpriosysfs.so
>
>  all: $(LIBS)
> @@ -25,6 +26,9 @@ all: $(LIBS)
>  libprioalua.so: alua.o alua_rtpg.o
>         $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>
> +libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
> +       $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
> +
>  libprio%.so: %.o
>         $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>
> diff --git a/libmultipath/prioritizers/path_latency.c
> b/libmultipath/prioritizers/path_latency.c
> new file mode 100644
> index 0000000..046e13b
> --- /dev/null
> +++ b/libmultipath/prioritizers/path_latency.c
> @@ -0,0 +1,257 @@
> +/*
> + * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
> + *
> + * path_latency.c
> + *
> + * Prioritizer for device mapper multipath, where the corresponding
> priority
> + * values of specific paths are provided by a latency algorithm. And the
> + * latency algorithm is dependent on arguments("io_num" and "base_num").
> + *
> + * The principle of the algorithm as follows:
> + * 1. By sending a certain number "io_num" of read IOs to the current path
> + *    continuously, the IOs' average latency can be calculated.
> + * 2. Max value and min value of average latency are constant. According
> to
> + *    the average latency of each path and the "base_num" of logarithmic
> + *    scale, the priority "rc" of each path can be provided.
> + *
> + * Author(s): Yang Feng <philip.yang@huawei.com>
> + *
> + * This file is released under the GPL version 2, or any later version.
> + *
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
> +#define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: "
> fmt, ##args)
> +
> +#define MAX_IO_NUM              200
> +#define MIN_IO_NUM              2
> +
> +#define MAX_BASE_NUM            10
> +#define MIN_BASE_NUM            2
> +
> +#define MAX_AVG_LATENCY         100000000.  /*Unit: us*/
> +#define MIN_AVG_LATENCY         1.          /*Unit: us*/
> +
> +#define DEFAULT_PRIORITY        0
> +
> +#define MAX_CHAR_SIZE           30
> +
> +#define USEC_PER_SEC            1000000LL
> +#define NSEC_PER_USEC           1000LL
> +
> +static long long path_latency[MAX_IO_NUM];
> +
> +static inline long long timeval_to_us(const struct timespec *tv)
> +{
> +       return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec /
> NSEC_PER_USEC);
> +}
> +
> +static int do_readsector0(int fd, unsigned int timeout)
> +{
> +       unsigned char buf[4096];
> +       unsigned char sbuf[SENSE_BUFF_LEN];
> +       int ret;
> +
> +       ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
> +                     SENSE_BUFF_LEN, timeout);
> +
> +       return ret;
> +}
> +
> +int check_args_valid(int io_num, int base_num)
> +{
> +    if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
> +    {
> +        pp_pl_log(0, "args io_num is outside the valid range");
> +        return 0;
> +    }
> +
> +    if ((base_num < MIN_BASE_NUM) || (base_num > MAX_BASE_NUM))
> +    {
> +        pp_pl_log(0, "args base_num is outside the valid range");
> +        return 0;
> +    }
> +
> +    return 1;
> +}
> +
> +/* In multipath.conf, args form: io_num|base_num. For example,
> +*  args is "20|10", this function can get io_num value 20, and
> +   base_num value 10.
> +*/
> +static int get_ionum_and_basenum(char *args,
> +                                 int *ionum,
> +                                 int *basenum)
> +{
> +    char source[MAX_CHAR_SIZE];
> +    char vertica = '|';
> +    char *endstrbefore = NULL;
> +    char *endstrafter = NULL;
> +    unsigned int size = strlen(args);
> +
> +    if ((args == NULL) || (ionum == NULL) || (basenum == NULL))
> +    {
> +        pp_pl_log(0, "args string is NULL");
> +        return 0;
> +    }
> +
> +    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
> +    {
> +        pp_pl_log(0, "args string's size is too long");
> +        return 0;
> +    }
> +
> +    memcpy(source, args, size+1);
> +
> +    if (!isdigit(source[0]))
> +    {
> +        pp_pl_log(0, "invalid prio_args format: %s", source);
> +        return 0;
> +    }
> +
> +    *ionum = (int)strtoul(source, &endstrbefore, 10);
> +    if (endstrbefore[0] != vertica)
> +    {
> +        pp_pl_log(0, "invalid prio_args format: %s", source);
> +        return 0;
> +    }
> +
> +    if (!isdigit(endstrbefore[1]))
> +    {
> +        pp_pl_log(0, "invalid prio_args format: %s", source);
> +        return 0;
> +    }
> +
> +    *basenum = (long long)strtol(&endstrbefore[1], &endstrafter, 10);
> +    if (check_args_valid(*ionum, *basenum) == 0)
> +    {
> +        return 0;
> +    }
> +
> +    return 1;
> +}
> +
> +long long calc_standard_deviation(long long *path_latency, int size, long
> long avglatency)
> +{
> +    int index;
> +    long long total = 0;
> +
> +    for (index = 0; index < size; index++)
> +    {
> +        total += (path_latency[index] - avglatency) *
> (path_latency[index] - avglatency);
> +    }
> +
> +    total /= (size-1);
> +
> +    return (long long)sqrt((double)total);
> +}
> +
> +int calcPrio(double avglatency, double max_avglatency, double
> min_avglatency, double base_num)
> +{
> +    double lavglatency = log(avglatency)/log(base_num);
> +    double lmax_avglatency = log(max_avglatency)/log(base_num);
> +    double lmin_avglatency = log(min_avglatency)/log(base_num);
> +
> +    if (lavglatency <= lmin_avglatency)
> +        return (int)(lmax_avglatency + 1.);
> +
> +    if (lavglatency > lmax_avglatency)
> +        return 0;
> +
> +    return (int)(lmax_avglatency - lavglatency + 1.);
> +}
> +
> +/* Calc the latency interval corresponding to the average latency */
> +long long calc_latency_interval(double avglatency, double max_avglatency,
> +                                double min_avglatency, double base_num)
> +{
> +    double lavglatency = log(avglatency)/log(base_num);
> +    double lmax_avglatency = log(max_avglatency)/log(base_num);
> +    double lmin_avglatency = log(min_avglatency)/log(base_num);
> +
> +    if ((lavglatency <= lmin_avglatency)
> +        || (lavglatency > lmax_avglatency))
> +        return 0;/* Invalid value */
> +
> +    if ((double)((int)lavglatency) == lavglatency)
> +        return (long long)(avglatency - (avglatency / base_num));
> +    else
> +        return (long long)(pow(base_num, (double)((int)lavglatency + 1))
> +            - pow(base_num, (double)((int)lavglatency)));
> +}
> +
> +int getprio (struct path *pp, char *args, unsigned int timeout)
> +{
> +    int rc, temp;
> +    int index = 0;
> +    int io_num;
> +    int base_num;
> +    long long avglatency;
> +    long long latency_interval;
> +    long long standard_deviation;
> +    long long toldelay = 0;
> +    long long before, after;
> +    struct timespec tv;
> +
> +    if (pp->fd < 0)
> +        return -1;
> +
> +    if (get_ionum_and_basenum(args, &io_num, &base_num) == 0)
> +    {
> +        pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
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
> +            pp_pl_log(0, "%s: path down", pp->dev);
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
> +    pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev, avglatency);
> +
> +    if (avglatency > MAX_AVG_LATENCY)
> +    {
> +        pp_pl_log(0, "%s: average latency (%lld us) is outside the
> thresold (%lld us)",
> +            pp->dev, avglatency, (long long)MAX_AVG_LATENCY);
> +        return DEFAULT_PRIORITY;
> +    }
> +
> +    /* Min average latency and max average latency are constant, the args
> base_num
> +    set can change latency_interval value corresponding to avglatency and
> is not constant.
> +    Warn the user if latency_interval is smaller than (2 *
> standard_deviation), or equal */
> +    standard_deviation = calc_standard_deviation(path_latency, index,
> avglatency);
> +    latency_interval = calc_latency_interval(avglatency,
> MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
> +    if ((latency_interval!= 0)
> +        && (latency_interval <= (2 * standard_deviation)))
> +        pp_pl_log(3, "%s: latency interval (%lld) according to average
> latency (%lld us) is smaller than "
> +            "2 * standard deviation (%lld us), or equal, args base_num
> (%d) needs to be set bigger value",
> +            pp->dev, latency_interval, avglatency, standard_deviation,
> base_num);
> +
> +    rc = calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
> +    return rc;
> +}
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 5939688..8dffac0 100644
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
> @@ -333,6 +337,22 @@ these values can be looked up through sysfs or by
> running \fImultipathd show pat
>  "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.*
> , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
>  .RE
>  .TP 12
> +.I path_latency
> +Needs a value of the form
> +\fI"<io_num>|<base_num>"\fR
> +.RS
> +.TP 8
> +.I io_num
> +The number of read IOs sent to the current path continuously, used to
> calculate the average path latency.
> +Valid Values: Integer, [2, 200].
> +.TP
> +.I base_num
> +The base number value of logarithmic scale, used to partition different
> priority ranks. Valid Values: Integer,
> +[2, 10]. And Max average latency value is 100s, min average latency value
> is 1us.
> +For example: If base_num=10, the paths will be grouped in priority groups
> with path latency <=1us, (1us, 10us],
> +(10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s],
> (1s, 10s], (10s, 100s], >100s.
> +.RE
> +.TP 12
>  .I alua
>  If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR
> bit
>  set will always be in their own path group.
> --
> 2.6.4.windows.1
>
>
>

--001a11c0060e13f18b055275bd78
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This version is now merged.<div>Thanks.</div><div><br></di=
v><div>Incremental enhancements can go from there if needed.</div></div><di=
v class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Jun 21, 2017=
 at 11:40 AM, Yang Feng <span dir=3D"ltr">&lt;<a href=3D"mailto:philip.yang=
@huawei.com" target=3D"_blank">philip.yang@huawei.com</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">libmultipath/prioritizers: Prioritizer f=
or device mapper multipath,<br>
where the corresponding priority values of specific paths are provided<br>
by a latency algorithm on the logarithmic scale. And the latency algorithm<=
br>
is dependent on the following arguments(io_num and base_num).<br>
The principle of the algorithm is illustrated as follows:<br>
1. By sending a certain number &quot;io_num&quot; of read IOs to the curren=
t<br>
path continuously, the IOs&#39; average latency can be calculated.<br>
2. Max average latency value is 100s, and min value is 1us. According<br>
to the average latency of each path and the &quot;base_number&quot; of loga=
rithmic<br>
scale, the priority &quot;rc&quot; of each path can be provided.<br>
<br>
For example: If base_num=3D10, the paths will be grouped in priority groups=
<br>
with path latency &lt;=3D1us, (1us, 10us], (10us, 100us], (100us, 1ms], (1m=
s, 10ms],<br>
(10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], &gt;100s. As follows:<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;=3D1us=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 (1us, 10us]=C2=A0 =C2=A0 =C2=A0 (10us, 100us]=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt;100s<br>
|------------------|----------<wbr>--------|------------------|..<wbr>.|---=
---------------|<br>
|=C2=A0 priority rank 9 |=C2=A0 priority rank 8 |=C2=A0 priority rank 7 |..=
.|=C2=A0 priority rank 0 |<br>
|------------------|----------<wbr>--------|------------------|..<wbr>.|---=
---------------|<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0Priority Rank Partitioning<br>
<br>
Signed-off-by: Yang Feng &lt;<a href=3D"mailto:philip.yang@huawei.com">phil=
ip.yang@huawei.com</a>&gt;<br>
Reviewed-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">=
bmarzins@redhat.com</a>&gt;<br>
Reviewed-by: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@sus=
e.com</a>&gt;<br>
Reviewed-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.co=
m">xose.vazquez@gmail.com</a>&gt;<br>
Reviewed-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.=
de</a>&gt;<br>
---<br>
<span class=3D"">=C2=A0libmultipath/prio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/prioritizers/<wbr>Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A04 +<br>
=C2=A0libmultipath/prioritizers/<wbr>path_latency.c | 257 +++++++++++++++++=
+++++++++++++<wbr>+<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 20 +++<br>
=C2=A04 files changed, 282 insertions(+)<br>
=C2=A0create mode 100644 libmultipath/prioritizers/<wbr>path_latency.c<br>
<br>
</span>diff --git a/libmultipath/prio.h b/libmultipath/prio.h<br>
index 0193c52..c97fe39 100644<br>
--- a/libmultipath/prio.h<br>
+++ b/libmultipath/prio.h<br>
@@ -29,6 +29,7 @@ struct path;<br>
=C2=A0#define PRIO_RDAC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &qu=
ot;rdac&quot;<br>
=C2=A0#define PRIO_WEIGHTED_PATH=C2=A0 =C2=A0 =C2=A0&quot;weightedpath&quot=
;<br>
=C2=A0#define PRIO_SYSFS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&qu=
ot;sysfs&quot;<br>
+#define PRIO_PATH_LATENCY=C2=A0 =C2=A0 =C2=A0 &quot;path_latency&quot;<br>
<br>
=C2=A0/*<br>
=C2=A0 * Value used to mark the fact prio was not defined<br>
diff --git a/libmultipath/prioritizers/<wbr>Makefile b/libmultipath/priorit=
izers/<wbr>Makefile<br>
index 36b42e4..ca47cdf 100644<br>
--- a/libmultipath/prioritizers/<wbr>Makefile<br>
+++ b/libmultipath/prioritizers/<wbr>Makefile<br>
@@ -18,6 +18,7 @@ LIBS =3D \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libpriorandom.so \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libpriordac.so \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libprioweightedpath.so \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0libpriopath_latency.so \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libpriosysfs.so<br>
<br>
=C2=A0all: $(LIBS)<br>
@@ -25,6 +26,9 @@ all: $(LIBS)<br>
=C2=A0libprioalua.so: alua.o alua_rtpg.o<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^<br>
<br>
+libpriopath_latency.so: path_latency.o=C2=A0 ../checkers/libsg.o<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm<b=
r>
+<br>
=C2=A0libprio%.so: %.o<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^<br>
<br>
diff --git a/libmultipath/prioritizers/<wbr>path_latency.c b/libmultipath/p=
rioritizers/<wbr>path_latency.c<br>
new file mode 100644<br>
index 0000000..046e13b<br>
--- /dev/null<br>
+++ b/libmultipath/prioritizers/<wbr>path_latency.c<br>
@@ -0,0 +1,257 @@<br>
+/*<br>
+ * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.<br>
+ *<br>
+ * path_latency.c<br>
+ *<br>
+ * Prioritizer for device mapper multipath, where the corresponding priori=
ty<br>
+ * values of specific paths are provided by a latency algorithm. And the<b=
r>
+ * latency algorithm is dependent on arguments(&quot;io_num&quot; and &quo=
t;base_num&quot;).<br>
+ *<br>
+ * The principle of the algorithm as follows:<br>
+ * 1. By sending a certain number &quot;io_num&quot; of read IOs to the cu=
rrent path<br>
+ *=C2=A0 =C2=A0 continuously, the IOs&#39; average latency can be calculat=
ed.<br>
+ * 2. Max value and min value of average latency are constant. According t=
o<br>
+ *=C2=A0 =C2=A0 the average latency of each path and the &quot;base_num&qu=
ot; of logarithmic<br>
+ *=C2=A0 =C2=A0 scale, the priority &quot;rc&quot; of each path can be pro=
vided.<br>
+ *<br>
+ * Author(s): Yang Feng &lt;<a href=3D"mailto:philip.yang@huawei.com">phil=
ip.yang@huawei.com</a>&gt;<br>
+ *<br>
+ * This file is released under the GPL version 2, or any later version.<br=
>
+ *<br>
+ */<br>
+#include &lt;stdio.h&gt;<br>
+#include &lt;math.h&gt;<br>
+#include &lt;ctype.h&gt;<br>
+#include &lt;time.h&gt;<br>
+<br>
+#include &quot;debug.h&quot;<br>
+#include &quot;prio.h&quot;<br>
+#include &quot;structs.h&quot;<br>
+#include &quot;../checkers/libsg.h&quot;<br>
+<br>
+#define pp_pl_log(prio, fmt, args...) condlog(prio, &quot;path_latency pri=
o: &quot; fmt, ##args)<br>
+<br>
+#define MAX_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 200<br>
+#define MIN_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2<br>
+<br>
+#define MAX_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 10<br>
+#define MIN_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2<br>
+<br>
+#define MAX_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0100000000.=C2=A0 =
/*Unit: us*/<br>
+#define MIN_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 /*Unit: us*/<br>
+<br>
+#define DEFAULT_PRIORITY=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
+<br>
+#define MAX_CHAR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A030<br>
+<br>
+#define USEC_PER_SEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1000000LL<br=
>
+#define NSEC_PER_USEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01000LL<br>
+<br>
+static long long path_latency[MAX_IO_NUM];<br>
+<br>
+static inline long long timeval_to_us(const struct timespec *tv)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ((long long) tv-&gt;tv_sec * USEC_PER_SE=
C) + (tv-&gt;tv_nsec / NSEC_PER_USEC);<br>
+}<br>
+<br>
+static int do_readsector0(int fd, unsigned int timeout)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char buf[4096];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char sbuf[SENSE_BUFF_LEN];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sg_read(fd, &amp;buf[0], 4096, &amp;sbu=
f[0],<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0SENSE_BUFF_LEN, timeout);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+}<br>
+<br>
+int check_args_valid(int io_num, int base_num)<br>
+{<br>
+=C2=A0 =C2=A0 if ((io_num &lt; MIN_IO_NUM) || (io_num &gt; MAX_IO_NUM))<br=
>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args io_num is outside the =
valid range&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 if ((base_num &lt; MIN_BASE_NUM) || (base_num &gt; MAX_BASE_=
NUM))<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args base_num is outside th=
e valid range&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 return 1;<br>
+}<br>
+<br>
+/* In multipath.conf, args form: io_num|base_num. For example,<br>
+*=C2=A0 args is &quot;20|10&quot;, this function can get io_num value 20, =
and<br>
+=C2=A0 =C2=A0base_num value 10.<br>
+*/<br>
+static int get_ionum_and_basenum(char *args,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *ionum,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *basenum)<br>
+{<br>
+=C2=A0 =C2=A0 char source[MAX_CHAR_SIZE];<br>
+=C2=A0 =C2=A0 char vertica =3D &#39;|&#39;;<br>
+=C2=A0 =C2=A0 char *endstrbefore =3D NULL;<br>
+=C2=A0 =C2=A0 char *endstrafter =3D NULL;<br>
+=C2=A0 =C2=A0 unsigned int size =3D strlen(args);<br>
+<br>
+=C2=A0 =C2=A0 if ((args =3D=3D NULL) || (ionum =3D=3D NULL) || (basenum =
=3D=3D NULL))<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args string is NULL&quot;);=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 if ((size &lt; 1) || (size &gt; MAX_CHAR_SIZE-1))<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args string&#39;s size is t=
oo long&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 memcpy(source, args, size+1);<br>
+<br>
+=C2=A0 =C2=A0 if (!isdigit(source[0]))<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args format: %=
s&quot;, source);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 *ionum =3D (int)strtoul(source, &amp;endstrbefore, 10);<br>
+=C2=A0 =C2=A0 if (endstrbefore[0] !=3D vertica)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args format: %=
s&quot;, source);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 if (!isdigit(endstrbefore[1]))<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args format: %=
s&quot;, source);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 *basenum =3D (long long)strtol(&amp;endstrbefore[1], &amp;en=
dstrafter, 10);<br>
+=C2=A0 =C2=A0 if (check_args_valid(*ionum, *basenum) =3D=3D 0)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 return 1;<br>
+}<br>
+<br>
+long long calc_standard_deviation(long long *path_latency, int size, long =
long avglatency)<br>
+{<br>
+=C2=A0 =C2=A0 int index;<br>
+=C2=A0 =C2=A0 long long total =3D 0;<br>
+<br>
+=C2=A0 =C2=A0 for (index =3D 0; index &lt; size; index++)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 total +=3D (path_latency[index] - avglatency) =
* (path_latency[index] - avglatency);<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 total /=3D (size-1);<br>
+<br>
+=C2=A0 =C2=A0 return (long long)sqrt((double)total);<br>
+}<br>
+<br>
+int calcPrio(double avglatency, double max_avglatency, double min_avglaten=
cy, double base_num)<br>
+{<br>
+=C2=A0 =C2=A0 double lavglatency =3D log(avglatency)/log(base_num);<br>
+=C2=A0 =C2=A0 double lmax_avglatency =3D log(max_avglatency)/log(base_<wbr=
>num);<br>
+=C2=A0 =C2=A0 double lmin_avglatency =3D log(min_avglatency)/log(base_<wbr=
>num);<br>
+<br>
+=C2=A0 =C2=A0 if (lavglatency &lt;=3D lmin_avglatency)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (int)(lmax_avglatency + 1.);<br>
+<br>
+=C2=A0 =C2=A0 if (lavglatency &gt; lmax_avglatency)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+<br>
+=C2=A0 =C2=A0 return (int)(lmax_avglatency - lavglatency + 1.);<br>
+}<br>
+<br>
+/* Calc the latency interval corresponding to the average latency */<br>
+long long calc_latency_interval(double avglatency, double max_avglatency,<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 double min_avglatency, double base_n=
um)<br>
+{<br>
+=C2=A0 =C2=A0 double lavglatency =3D log(avglatency)/log(base_num);<br>
+=C2=A0 =C2=A0 double lmax_avglatency =3D log(max_avglatency)/log(base_<wbr=
>num);<br>
+=C2=A0 =C2=A0 double lmin_avglatency =3D log(min_avglatency)/log(base_<wbr=
>num);<br>
+<br>
+=C2=A0 =C2=A0 if ((lavglatency &lt;=3D lmin_avglatency)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 || (lavglatency &gt; lmax_avglatency))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;/* Invalid value */<br>
+<br>
+=C2=A0 =C2=A0 if ((double)((int)lavglatency) =3D=3D lavglatency)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (long long)(avglatency - (avglatency / =
base_num));<br>
+=C2=A0 =C2=A0 else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (long long)(pow(base_num, (double)((int=
)lavglatency + 1))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - pow(base_num, (double)((int)la=
vglatency)));<br>
+}<br>
+<br>
+int getprio (struct path *pp, char *args, unsigned int timeout)<br>
+{<br>
+=C2=A0 =C2=A0 int rc, temp;<br>
+=C2=A0 =C2=A0 int index =3D 0;<br>
+=C2=A0 =C2=A0 int io_num;<br>
+=C2=A0 =C2=A0 int base_num;<br>
+=C2=A0 =C2=A0 long long avglatency;<br>
+=C2=A0 =C2=A0 long long latency_interval;<br>
+=C2=A0 =C2=A0 long long standard_deviation;<br>
+=C2=A0 =C2=A0 long long toldelay =3D 0;<br>
+=C2=A0 =C2=A0 long long before, after;<br>
+=C2=A0 =C2=A0 struct timespec tv;<br>
+<br>
+=C2=A0 =C2=A0 if (pp-&gt;fd &lt; 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
+<br>
+=C2=A0 =C2=A0 if (get_ionum_and_basenum(args, &amp;io_num, &amp;base_num) =
=3D=3D 0)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: get path_latency args f=
ail&quot;, pp-&gt;dev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return DEFAULT_PRIORITY;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 memset(path_latency, 0, sizeof(path_latency));<br>
+<br>
+=C2=A0 =C2=A0 temp =3D io_num;<br>
+=C2=A0 =C2=A0 while (temp-- &gt; 0)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 (void)clock_gettime(CLOCK_<wbr>MONOTONIC, &amp=
;tv);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 before =3D timeval_to_us(&amp;tv);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (do_readsector0(pp-&gt;fd, timeout) =3D=3D =
2)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: path down=
&quot;, pp-&gt;dev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 (void)clock_gettime(CLOCK_<wbr>MONOTONIC, &amp=
;tv);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 after =3D timeval_to_us(&amp;tv);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 path_latency[index] =3D after - before;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 toldelay +=3D path_latency[index++];<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 avglatency =3D toldelay/(long long)io_num;<br>
+=C2=A0 =C2=A0 pp_pl_log(4, &quot;%s: average latency is (%lld us)&quot;, p=
p-&gt;dev, avglatency);<br>
+<br>
+=C2=A0 =C2=A0 if (avglatency &gt; MAX_AVG_LATENCY)<br>
+=C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: average latency (%lld u=
s) is outside the thresold (%lld us)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, avglatency, (long lo=
ng)MAX_AVG_LATENCY);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return DEFAULT_PRIORITY;<br>
+=C2=A0 =C2=A0 }<br>
+<br>
+=C2=A0 =C2=A0 /* Min average latency and max average latency are constant,=
 the args base_num<br>
+=C2=A0 =C2=A0 set can change latency_interval value corresponding to avgla=
tency and is not constant.<br>
+=C2=A0 =C2=A0 Warn the user if latency_interval is smaller than (2 * stand=
ard_deviation), or equal */<br>
+=C2=A0 =C2=A0 standard_deviation =3D calc_standard_deviation(path_<wbr>lat=
ency, index, avglatency);<br>
+=C2=A0 =C2=A0 latency_interval =3D calc_latency_interval(<wbr>avglatency, =
MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);<br>
+=C2=A0 =C2=A0 if ((latency_interval!=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;&amp; (latency_interval &lt;=3D (2 * stan=
dard_deviation)))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(3, &quot;%s: latency interval (%lld)=
 according to average latency (%lld us) is smaller than &quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;2 * standard deviation (%l=
ld us), or equal, args base_num (%d) needs to be set bigger value&quot;,<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, latency_interval, av=
glatency, standard_deviation, base_num);<br>
+<br>
+=C2=A0 =C2=A0 rc =3D calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY=
, base_num);<br>
+=C2=A0 =C2=A0 return rc;<br>
+}<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 5939688..8dffac0 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -293,6 +293,10 @@ Generate a random priority between 1 and 10.<br>
=C2=A0Generate the path priority based on the regular expression and the<br=
>
=C2=A0priority provided as argument. Requires prio_args keyword.<br>
=C2=A0.TP<br>
+.I path_latency<br>
+Generate the path priority based on a latency algorithm.<br>
+Requires prio_args keyword.<br>
+.TP<br>
=C2=A0.I datacore<br>
=C2=A0.\&quot; XXX<br>
=C2=A0???. Requires prio_args keyword.<br>
@@ -333,6 +337,22 @@ these values can be looked up through sysfs or by runn=
ing \fImultipathd show pat<br>
=C2=A0&quot;%N:%R:%n:%r&quot;\fR. For example: 0x200100e08ba0aea0:<wbr>0x21=
0100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.<wbr>msp.lab.ask-06:.*<=
br>
=C2=A0.RE<br>
=C2=A0.TP 12<br>
+.I path_latency<br>
+Needs a value of the form<br>
+\fI&quot;&lt;io_num&gt;|&lt;base_num&gt;&quot;\fR<br>
+.RS<br>
+.TP 8<br>
+.I io_num<br>
+The number of read IOs sent to the current path continuously, used to calc=
ulate the average path latency.<br>
+Valid Values: Integer, [2, 200].<br>
+.TP<br>
+.I base_num<br>
+The base number value of logarithmic scale, used to partition different pr=
iority ranks. Valid Values: Integer,<br>
+[2, 10]. And Max average latency value is 100s, min average latency value =
is 1us.<br>
+For example: If base_num=3D10, the paths will be grouped in priority group=
s with path latency &lt;=3D1us, (1us, 10us],<br>
+(10us, 100us], (100us, 1ms], (1ms, 10ms], (10ms, 100ms], (100ms, 1s], (1s,=
 10s], (10s, 100s], &gt;100s.<br>
+.RE<br>
+.TP 12<br>
=C2=A0.I alua<br>
=C2=A0If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\=
fR bit<br>
=C2=A0set will always be in their own path group.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.4.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c0060e13f18b055275bd78--


--===============4714149889952481295==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4714149889952481295==--
