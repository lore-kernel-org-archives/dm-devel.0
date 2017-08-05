From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: beautify path_latency.c code
Date: Sat, 5 Aug 2017 08:32:11 +0200
Message-ID: <CABr-GnfmgNDE+AmN7+XjwqQqUn+hHX0F7vseH5T2Mju22OxnJg@mail.gmail.com>
References: <20170622164623.4511-1-xose.vazquez@gmail.com>
	<bc17589f-50a9-bb68-b336-2ebfd8f74dbc@gmail.com>
	<CABr-Gnc8iqDhF5r_QaCiKc9QyinX7F-AYOO_SqH=RXSHeET_RQ@mail.gmail.com>
	<1501867468.2757.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1138902448465869177=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1501867468.2757.19.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "philip.yang@huawei.com" <philip.yang@huawei.com>
List-Id: dm-devel.ids

--===============1138902448465869177==
Content-Type: multipart/alternative; boundary="94eb2c0933a81901940555fbc6dc"

--94eb2c0933a81901940555fbc6dc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ok, done.

On Fri, Aug 4, 2017 at 7:24 PM, Bart Van Assche <Bart.VanAssche@wdc.com>
wrote:

> Hello Christophe,
>
> Thanks for asking. I have one pending patch for which I have not yet had
> the time to post it on the dm-devel mailing list but it does not affect t=
he
> libmultipath/prioritizers/path_latency.c source file. So please proceed
> with merging Xose's patch.
>
> Bart.
>
> On Fri, 2017-08-04 at 19:18 +0200, Christophe Varoqui wrote:
>
> Bart,
>
> Do you have pending patches on this file you'd like to submit before I
> merge this l'indentation patch ?
>
> Regards,
> Christophe
>
> Le 4 ao=C3=BBt 2017 18:39, "Xose Vazquez Perez" <xose.vazquez@gmail.com> =
a
> =C3=A9crit :
>
> On 06/22/2017 06:46 PM, Xose Vazquez Perez wrote:
>
> > Mainly running scripts/Lindent, from kernel dir, to replace indent spac=
es
> > by tabs.
>
> Patch missing in last merge.
>
> > Cc: Yang Feng <philip.yang@huawei.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/prioritizers/path_latency.c | 354
> +++++++++++++++----------------
> >  1 file changed, 177 insertions(+), 177 deletions(-)
> >
> > diff --git a/libmultipath/prioritizers/path_latency.c
> b/libmultipath/prioritizers/path_latency.c
> > index 34b734b..9fc2dfc 100644
> > --- a/libmultipath/prioritizers/path_latency.c
> > +++ b/libmultipath/prioritizers/path_latency.c
> > @@ -17,8 +17,8 @@
> >   * Author(s): Yang Feng <philip.yang@huawei.com>
> >   *
> >   * This file is released under the GPL version 2, or any later version=
.
> > - *
> >   */
> > +
> >  #include <stdio.h>
> >  #include <math.h>
> >  #include <ctype.h>
> > @@ -31,27 +31,28 @@
> >
> >  #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio=
:
> " fmt, ##args)
> >
> > -#define MAX_IO_NUM              200
> > -#define MIN_IO_NUM              2
> > +#define MAX_IO_NUM           200
> > +#define MIN_IO_NUM           2
> >
> > -#define MAX_BASE_NUM            10
> > -#define MIN_BASE_NUM            2
> > +#define MAX_BASE_NUM         10
> > +#define MIN_BASE_NUM         2
> >
> > -#define MAX_AVG_LATENCY         100000000.  /*Unit: us*/
> > -#define MIN_AVG_LATENCY         1.          /*Unit: us*/
> > +#define MAX_AVG_LATENCY              100000000.      /* Unit: us */
> > +#define MIN_AVG_LATENCY              1.              /* Unit: us */
> >
> > -#define DEFAULT_PRIORITY        0
> > +#define DEFAULT_PRIORITY     0
> >
> > -#define MAX_CHAR_SIZE           30
> > +#define MAX_CHAR_SIZE                30
> >
> > -#define USEC_PER_SEC            1000000LL
> > -#define NSEC_PER_USEC           1000LL
> > +#define USEC_PER_SEC         1000000LL
> > +#define NSEC_PER_USEC                1000LL
> >
> >  static long long path_latency[MAX_IO_NUM];
> >
> >  static inline long long timeval_to_us(const struct timespec *tv)
> >  {
> > -     return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec /
> NSEC_PER_USEC);
> > +     return ((long long)tv->tv_sec * USEC_PER_SEC) +
> > +         (tv->tv_nsec / NSEC_PER_USEC);
> >  }
> >
> >  static int do_readsector0(int fd, unsigned int timeout)
> > @@ -60,198 +61,197 @@ static int do_readsector0(int fd, unsigned int
> timeout)
> >       unsigned char sbuf[SENSE_BUFF_LEN];
> >       int ret;
> >
> > -     ret =3D sg_read(fd, &buf[0], 4096, &sbuf[0],
> > -                   SENSE_BUFF_LEN, timeout);
> > +     ret =3D sg_read(fd, &buf[0], 4096, &sbuf[0], SENSE_BUFF_LEN,
> timeout);
> >
> >       return ret;
> >  }
> >
> >  int check_args_valid(int io_num, int base_num)
> >  {
> > -    if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM))
> > -    {
> > -        pp_pl_log(0, "args io_num is outside the valid range");
> > -        return 0;
> > -    }
> > -
> > -    if ((base_num < MIN_BASE_NUM) || (base_num > MAX_BASE_NUM))
> > -    {
> > -        pp_pl_log(0, "args base_num is outside the valid range");
> > -        return 0;
> > -    }
> > -
> > -    return 1;
> > +     if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM)) {
> > +             pp_pl_log(0, "args io_num is outside the valid range");
> > +             return 0;
> > +     }
> > +
> > +     if ((base_num < MIN_BASE_NUM) || (base_num > MAX_BASE_NUM)) {
> > +             pp_pl_log(0, "args base_num is outside the valid range");
> > +             return 0;
> > +     }
> > +
> > +     return 1;
> >  }
> >
> > -/* In multipath.conf, args form: io_num|base_num. For example,
> > -*  args is "20|10", this function can get io_num value 20, and
> > -   base_num value 10.
> > -*/
> > -static int get_ionum_and_basenum(char *args,
> > -                                 int *ionum,
> > -                                 int *basenum)
> > +/*
> > + * In multipath.conf, args form: io_num|base_num. For example,
> > + * args is "20|10", this function can get io_num value 20, and
> > + * base_num value 10.
> > + */
> > +static int get_ionum_and_basenum(char *args, int *ionum, int *basenum)
> >  {
> > -    char source[MAX_CHAR_SIZE];
> > -    char vertica =3D '|';
> > -    char *endstrbefore =3D NULL;
> > -    char *endstrafter =3D NULL;
> > -    unsigned int size =3D strlen(args);
> > -
> > -    if ((args =3D=3D NULL) || (ionum =3D=3D NULL) || (basenum =3D=3D N=
ULL))
> > -    {
> > -        pp_pl_log(0, "args string is NULL");
> > -        return 0;
> > -    }
> > -
> > -    if ((size < 1) || (size > MAX_CHAR_SIZE-1))
> > -    {
> > -        pp_pl_log(0, "args string's size is too long");
> > -        return 0;
> > -    }
> > -
> > -    memcpy(source, args, size+1);
> > -
> > -    if (!isdigit(source[0]))
> > -    {
> > -        pp_pl_log(0, "invalid prio_args format: %s", source);
> > -        return 0;
> > -    }
> > -
> > -    *ionum =3D (int)strtoul(source, &endstrbefore, 10);
> > -    if (endstrbefore[0] !=3D vertica)
> > -    {
> > -        pp_pl_log(0, "invalid prio_args format: %s", source);
> > -        return 0;
> > -    }
> > -
> > -    if (!isdigit(endstrbefore[1]))
> > -    {
> > -        pp_pl_log(0, "invalid prio_args format: %s", source);
> > -        return 0;
> > -    }
> > -
> > -    *basenum =3D (long long)strtol(&endstrbefore[1], &endstrafter, 10)=
;
> > -    if (check_args_valid(*ionum, *basenum) =3D=3D 0)
> > -    {
> > -        return 0;
> > -    }
> > -
> > -    return 1;
> > +     char source[MAX_CHAR_SIZE];
> > +     char vertica =3D '|';
> > +     char *endstrbefore =3D NULL;
> > +     char *endstrafter =3D NULL;
> > +     unsigned int size =3D strlen(args);
> > +
> > +     if ((args =3D=3D NULL) || (ionum =3D=3D NULL) || (basenum =3D=3D =
NULL)) {
> > +             pp_pl_log(0, "args string is NULL");
> > +             return 0;
> > +     }
> > +
> > +     if ((size < 1) || (size > MAX_CHAR_SIZE - 1)) {
> > +             pp_pl_log(0, "args string's size is too long");
> > +             return 0;
> > +     }
> > +
> > +     memcpy(source, args, size + 1);
> > +
> > +     if (!isdigit(source[0])) {
> > +             pp_pl_log(0, "invalid prio_args format: %s", source);
> > +             return 0;
> > +     }
> > +
> > +     *ionum =3D (int)strtoul(source, &endstrbefore, 10);
> > +     if (endstrbefore[0] !=3D vertica) {
> > +             pp_pl_log(0, "invalid prio_args format: %s", source);
> > +             return 0;
> > +     }
> > +
> > +     if (!isdigit(endstrbefore[1])) {
> > +             pp_pl_log(0, "invalid prio_args format: %s", source);
> > +             return 0;
> > +     }
> > +
> > +     *basenum =3D (long long)strtol(&endstrbefore[1], &endstrafter, 10=
);
> > +     if (check_args_valid(*ionum, *basenum) =3D=3D 0) {
> > +             return 0;
> > +     }
> > +
> > +     return 1;
> >  }
> >
> > -long long calc_standard_deviation(long long *path_latency, int size,
> long long avglatency)
> > +long long calc_standard_deviation(long long *path_latency, int size,
> > +                               long long avglatency)
> >  {
> > -    int index;
> > -    long long total =3D 0;
> > +     int index;
> > +     long long total =3D 0;
> >
> > -    for (index =3D 0; index < size; index++)
> > -    {
> > -        total +=3D (path_latency[index] - avglatency) *
> (path_latency[index] - avglatency);
> > -    }
> > +     for (index =3D 0; index < size; index++) {
> > +             total +=3D
> > +                 (path_latency[index] - avglatency) *
> (path_latency[index] -
> > +                                                       avglatency);
> > +     }
> >
> > -    total /=3D (size-1);
> > +     total /=3D (size - 1);
> >
> > -    return (long long)sqrt((double)total);
> > +     return (long long)sqrt((double)total);
> >  }
> >
> > -int calcPrio(double avglatency, double max_avglatency, double
> min_avglatency, double base_num)
> > +int calcPrio(double avglatency, double max_avglatency, double
> min_avglatency,
> > +          double base_num)
> >  {
> > -    double lavglatency =3D log(avglatency)/log(base_num);
> > -    double lmax_avglatency =3D log(max_avglatency)/log(base_num);
> > -    double lmin_avglatency =3D log(min_avglatency)/log(base_num);
> > +     double lavglatency =3D log(avglatency) / log(base_num);
> > +     double lmax_avglatency =3D log(max_avglatency) / log(base_num);
> > +     double lmin_avglatency =3D log(min_avglatency) / log(base_num);
> >
> > -    if (lavglatency <=3D lmin_avglatency)
> > -        return (int)(lmax_avglatency + 1.);
> > +     if (lavglatency <=3D lmin_avglatency)
> > +             return (int)(lmax_avglatency + 1.);
> >
> > -    if (lavglatency > lmax_avglatency)
> > -        return 0;
> > +     if (lavglatency > lmax_avglatency)
> > +             return 0;
> >
> > -    return (int)(lmax_avglatency - lavglatency + 1.);
> > +     return (int)(lmax_avglatency - lavglatency + 1.);
> >  }
> >
> >  /* Calc the latency interval corresponding to the average latency */
> >  long long calc_latency_interval(double avglatency, double
> max_avglatency,
> > -                                double min_avglatency, double base_num=
)
> > +                             double min_avglatency, double base_num)
> >  {
> > -    double lavglatency =3D log(avglatency)/log(base_num);
> > -    double lmax_avglatency =3D log(max_avglatency)/log(base_num);
> > -    double lmin_avglatency =3D log(min_avglatency)/log(base_num);
> > -
> > -    if ((lavglatency <=3D lmin_avglatency)
> > -        || (lavglatency > lmax_avglatency))
> > -        return 0;/* Invalid value */
> > -
> > -    if ((double)((int)lavglatency) =3D=3D lavglatency)
> > -        return (long long)(avglatency - (avglatency / base_num));
> > -    else
> > -        return (long long)(pow(base_num, (double)((int)lavglatency + 1=
))
> > -            - pow(base_num, (double)((int)lavglatency)));
> > +     double lavglatency =3D log(avglatency) / log(base_num);
> > +     double lmax_avglatency =3D log(max_avglatency) / log(base_num);
> > +     double lmin_avglatency =3D log(min_avglatency) / log(base_num);
> > +
> > +     if ((lavglatency <=3D lmin_avglatency)
> > +         || (lavglatency > lmax_avglatency))
> > +             return 0;       /* Invalid value */
> > +
> > +     if ((double)((int)lavglatency) =3D=3D lavglatency)
> > +             return (long long)(avglatency - (avglatency / base_num));
> > +     else
> > +             return (long long)(pow(base_num, (double)((int)lavglatenc=
y
> + 1))
> > +                                - pow(base_num,
> (double)((int)lavglatency)));
> >  }
> >
> > -int getprio (struct path *pp, char *args, unsigned int timeout)
> > +int getprio(struct path *pp, char *args, unsigned int timeout)
> >  {
> > -    int rc, temp;
> > -    int index =3D 0;
> > -    int io_num;
> > -    int base_num;
> > -    long long avglatency;
> > -    long long latency_interval;
> > -    long long standard_deviation;
> > -    long long toldelay =3D 0;
> > -    long long before, after;
> > -    struct timespec tv;
> > -
> > -    if (pp->fd < 0)
> > -        return -1;
> > -
> > -    if (get_ionum_and_basenum(args, &io_num, &base_num) =3D=3D 0)
> > -    {
> > -        pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
> > -        return DEFAULT_PRIORITY;
> > -    }
> > -
> > -    memset(path_latency, 0, sizeof(path_latency));
> > -
> > -    temp =3D io_num;
> > -    while (temp-- > 0)
> > -    {
> > -        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> > -        before =3D timeval_to_us(&tv);
> > -
> > -        if (do_readsector0(pp->fd, timeout) =3D=3D 2)
> > -        {
> > -            pp_pl_log(0, "%s: path down", pp->dev);
> > -            return -1;
> > -        }
> > -
> > -        (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> > -        after =3D timeval_to_us(&tv);
> > -
> > -        path_latency[index] =3D after - before;
> > -        toldelay +=3D path_latency[index++];
> > -    }
> > -
> > -    avglatency =3D toldelay/(long long)io_num;
> > -    pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev,
> avglatency);
> > -
> > -    if (avglatency > MAX_AVG_LATENCY)
> > -    {
> > -        pp_pl_log(0, "%s: average latency (%lld us) is outside the
> thresold (%lld us)",
> > -            pp->dev, avglatency, (long long)MAX_AVG_LATENCY);
> > -        return DEFAULT_PRIORITY;
> > -    }
> > -
> > -    /* Min average latency and max average latency are constant, the
> args base_num
> > -    set can change latency_interval value corresponding to avglatency
> and is not constant.
> > -    Warn the user if latency_interval is smaller than (2 *
> standard_deviation), or equal */
> > -    standard_deviation =3D calc_standard_deviation(path_latency, index=
,
> avglatency);
> > -    latency_interval =3D calc_latency_interval(avglatency,
> MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
> > -    if ((latency_interval!=3D 0)
> > -        && (latency_interval <=3D (2 * standard_deviation)))
> > -        pp_pl_log(3, "%s: latency interval (%lld) according to average
> latency (%lld us) is smaller than "
> > -            "2 * standard deviation (%lld us), or equal, args base_num
> (%d) needs to be set bigger value",
> > -            pp->dev, latency_interval, avglatency, standard_deviation,
> base_num);
> > -
> > -    rc =3D calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY,
> base_num);
> > -    return rc;
> > +     int rc, temp;
> > +     int index =3D 0;
> > +     int io_num;
> > +     int base_num;
> > +     long long avglatency;
> > +     long long latency_interval;
> > +     long long standard_deviation;
> > +     long long toldelay =3D 0;
> > +     long long before, after;
> > +     struct timespec tv;
> > +
> > +     if (pp->fd < 0)
> > +             return -1;
> > +
> > +     if (get_ionum_and_basenum(args, &io_num, &base_num) =3D=3D 0) {
> > +             pp_pl_log(0, "%s: get path_latency args fail", pp->dev);
> > +             return DEFAULT_PRIORITY;
> > +     }
> > +
> > +     memset(path_latency, 0, sizeof(path_latency));
> > +
> > +     temp =3D io_num;
> > +     while (temp-- > 0) {
> > +             (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> > +             before =3D timeval_to_us(&tv);
> > +
> > +             if (do_readsector0(pp->fd, timeout) =3D=3D 2) {
> > +                     pp_pl_log(0, "%s: path down", pp->dev);
> > +                     return -1;
> > +             }
> > +
> > +             (void)clock_gettime(CLOCK_MONOTONIC, &tv);
> > +             after =3D timeval_to_us(&tv);
> > +
> > +             path_latency[index] =3D after - before;
> > +             toldelay +=3D path_latency[index++];
> > +     }
> > +
> > +     avglatency =3D toldelay / (long long)io_num;
> > +     pp_pl_log(4, "%s: average latency is (%lld us)", pp->dev,
> avglatency);
> > +
> > +     if (avglatency > MAX_AVG_LATENCY) {
> > +             pp_pl_log(0,
> > +                       "%s: average latency (%lld us) is outside the
> thresold (%lld us)",
> > +                       pp->dev, avglatency, (long long)MAX_AVG_LATENCY=
);
> > +             return DEFAULT_PRIORITY;
> > +     }
> > +
> > +     /*
> > +      * Min average latency and max average latency are constant, the
> args
> > +      * base_num set can change latency_interval value corresponding t=
o
> > +      * avglatency and is not constant.
> > +      * Warn the user if latency_interval is smaller than (2 *
> standard_deviation),
> > +      * or equal.
> > +      */
> > +     standard_deviation =3D
> > +         calc_standard_deviation(path_latency, index, avglatency);
> > +     latency_interval =3D
> > +         calc_latency_interval(avglatency, MAX_AVG_LATENCY,
> MIN_AVG_LATENCY,
> > +                               base_num);
> > +     if ((latency_interval !=3D 0)
> > +         && (latency_interval <=3D (2 * standard_deviation)))
> > +             pp_pl_log(3,
> > +                       "%s: latency interval (%lld) according to
> average latency (%lld us) is smaller than "
> > +                       "2 * standard deviation (%lld us), or equal,
> args base_num (%d) needs to be set bigger value",
> > +                       pp->dev, latency_interval, avglatency,
> > +                       standard_deviation, base_num);
> > +
> > +     rc =3D calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY,
> base_num);
> > +     return rc;
> >  }
> >
>
>
>

--94eb2c0933a81901940555fbc6dc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok, done.</div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Fri, Aug 4, 2017 at 7:24 PM, Bart Van Assche <span dir=
=3D"ltr">&lt;<a href=3D"mailto:Bart.VanAssche@wdc.com" target=3D"_blank">Ba=
rt.VanAssche@wdc.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">



<div>
<div>Hello Christophe,</div>
<div><br>
</div>
<div>Thanks for asking. I have one pending patch for which I have not yet h=
ad the time to post it on the dm-devel mailing list but it does not affect =
the libmultipath/prioritizers/path<wbr>_latency.c source file. So please pr=
oceed with merging Xose&#39;s patch.</div><span class=3D"HOEnZb"><font colo=
r=3D"#888888">
<div><br>
</div>
<div>Bart.</div></font></span><div><div class=3D"h5">
<div><br>
</div>
<div>On Fri, 2017-08-04 at 19:18 +0200, Christophe Varoqui wrote:</div>
<blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;border-left:2px #729fc=
f solid;padding-left:1ex">
<div dir=3D"auto">Bart,
<div dir=3D"auto"><br>
</div>
<div dir=3D"auto">Do you have pending patches on this file you&#39;d like t=
o submit before I merge this l&#39;indentation patch ?</div>
<div dir=3D"auto"><br>
</div>
<div dir=3D"auto">Regards,</div>
<div dir=3D"auto">Christophe=C2=A0</div>
</div>
<div class=3D"gmail_extra"><br>
<div class=3D"gmail_quote">Le=C2=A04 ao=C3=BBt 2017 18:39, &quot;Xose Vazqu=
ez Perez&quot; &lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_bla=
nk">xose.vazquez@gmail.com</a>&gt; a =C3=A9crit=C2=A0:<br type=3D"attributi=
on">
<blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex;border-left:2px #729fc=
f solid;padding-left:1ex">
On 06/22/2017 06:46 PM, Xose Vazquez Perez wrote:<br>
<br>
&gt; Mainly running scripts/Lindent, from kernel dir, to replace indent spa=
ces<br>
&gt; by tabs.<br>
<br>
Patch missing in last merge.<br>
<br>
&gt; Cc: Yang Feng &lt;<a href=3D"mailto:philip.yang@huawei.com" target=3D"=
_blank">philip.yang@huawei.com</a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com" target=3D"_blank">christophe.varoqui@opensvc.co<wbr>m</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m" target=3D"_blank">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/prioritizers/path<wbr>_latency.c | 354 ++++++++++++=
+++---------------<wbr>-<br>
&gt;=C2=A0 1 file changed, 177 insertions(+), 177 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/prioritizers/pa<wbr>th_latency.c b/libmultip=
ath/prioritizers/pa<wbr>th_latency.c<br>
&gt; index 34b734b..9fc2dfc 100644<br>
&gt; --- a/libmultipath/prioritizers/pa<wbr>th_latency.c<br>
&gt; +++ b/libmultipath/prioritizers/pa<wbr>th_latency.c<br>
&gt; @@ -17,8 +17,8 @@<br>
&gt;=C2=A0 =C2=A0* Author(s): Yang Feng &lt;<a href=3D"mailto:philip.yang@h=
uawei.com" target=3D"_blank">philip.yang@huawei.com</a>&gt;<br>
&gt;=C2=A0 =C2=A0*<br>
&gt;=C2=A0 =C2=A0* This file is released under the GPL version 2, or any la=
ter version.<br>
&gt; - *<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt; +<br>
&gt;=C2=A0 #include &lt;stdio.h&gt;<br>
&gt;=C2=A0 #include &lt;math.h&gt;<br>
&gt;=C2=A0 #include &lt;ctype.h&gt;<br>
&gt; @@ -31,27 +31,28 @@<br>
&gt;<br>
&gt;=C2=A0 #define pp_pl_log(prio, fmt, args...) condlog(prio, &quot;path_l=
atency prio: &quot; fmt, ##args)<br>
&gt;<br>
&gt; -#define MAX_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 20=
0<br>
&gt; -#define MIN_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2<=
br>
&gt; +#define MAX_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0200<br>
&gt; +#define MIN_IO_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02<br>
&gt;<br>
&gt; -#define MAX_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 10<br>
&gt; -#define MIN_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2<br>
&gt; +#define MAX_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A010<br>
&gt; +#define MIN_BASE_NUM=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02<br>
&gt;<br>
&gt; -#define MAX_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0100000000.=
=C2=A0 /*Unit: us*/<br>
&gt; -#define MIN_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01.=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 /*Unit: us*/<br>
&gt; +#define MAX_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 100000000.=C2=A0 =C2=A0 =C2=A0 /* Unit: us */<br>
&gt; +#define MIN_AVG_LATENCY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 1.=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Unit: us */<br>
&gt;<br>
&gt; -#define DEFAULT_PRIORITY=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
&gt; +#define DEFAULT_PRIORITY=C2=A0 =C2=A0 =C2=A00<br>
&gt;<br>
&gt; -#define MAX_CHAR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A030<br>
&gt; +#define MAX_CHAR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 30<br>
&gt;<br>
&gt; -#define USEC_PER_SEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1000000=
LL<br>
&gt; -#define NSEC_PER_USEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01000LL<=
br>
&gt; +#define USEC_PER_SEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01000000LL<br>
&gt; +#define NSEC_PER_USEC=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 1000LL<br>
&gt;<br>
&gt;=C2=A0 static long long path_latency[MAX_IO_NUM];<br>
&gt;<br>
&gt;=C2=A0 static inline long long timeval_to_us(const struct timespec *tv)=
<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ((long long) tv-&gt;tv_sec * USEC_PER_SEC)=
 + (tv-&gt;tv_nsec / NSEC_PER_USEC);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ((long long)tv-&gt;tv_sec * USEC_PER_SEC) =
+<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(tv-&gt;tv_nsec / NSEC_PER_USEC);<b=
r>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int do_readsector0(int fd, unsigned int timeout)<br>
&gt; @@ -60,198 +61,197 @@ static int do_readsector0(int fd, unsigned int t=
imeout)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char sbuf[SENSE_BUFF_LEN];<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0ret =3D sg_read(fd, &amp;buf[0], 4096, &amp;sbuf[=
0],<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
SENSE_BUFF_LEN, timeout);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ret =3D sg_read(fd, &amp;buf[0], 4096, &amp;sbuf[=
0], SENSE_BUFF_LEN, timeout);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 int check_args_valid(int io_num, int base_num)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 if ((io_num &lt; MIN_IO_NUM) || (io_num &gt; MAX_IO_NUM=
))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args io_num is outside=
 the valid range&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if ((base_num &lt; MIN_BASE_NUM) || (base_num &gt; MAX_=
BASE_NUM))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args base_num is outsi=
de the valid range&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((io_num &lt; MIN_IO_NUM) || (io_num &gt; MAX_=
IO_NUM)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;ar=
gs io_num is outside the valid range&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((base_num &lt; MIN_BASE_NUM) || (base_num &gt=
; MAX_BASE_NUM)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;ar=
gs base_num is outside the valid range&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -/* In multipath.conf, args form: io_num|base_num. For example,<br>
&gt; -*=C2=A0 args is &quot;20|10&quot;, this function can get io_num value=
 20, and<br>
&gt; -=C2=A0 =C2=A0base_num value 10.<br>
&gt; -*/<br>
&gt; -static int get_ionum_and_basenum(char *args,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *ionum,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int *basenum)<br>
&gt; +/*<br>
&gt; + * In multipath.conf, args form: io_num|base_num. For example,<br>
&gt; + * args is &quot;20|10&quot;, this function can get io_num value 20, =
and<br>
&gt; + * base_num value 10.<br>
&gt; + */<br>
&gt; +static int get_ionum_and_basenum(char *args, int *ionum, int *basenum=
)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 char source[MAX_CHAR_SIZE];<br>
&gt; -=C2=A0 =C2=A0 char vertica =3D &#39;|&#39;;<br>
&gt; -=C2=A0 =C2=A0 char *endstrbefore =3D NULL;<br>
&gt; -=C2=A0 =C2=A0 char *endstrafter =3D NULL;<br>
&gt; -=C2=A0 =C2=A0 unsigned int size =3D strlen(args);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if ((args =3D=3D NULL) || (ionum =3D=3D NULL) || (basen=
um =3D=3D NULL))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args string is NULL&qu=
ot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if ((size &lt; 1) || (size &gt; MAX_CHAR_SIZE-1))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;args string&#39;s size=
 is too long&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 memcpy(source, args, size+1);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (!isdigit(source[0]))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args form=
at: %s&quot;, source);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 *ionum =3D (int)strtoul(source, &amp;endstrbefore, 10);=
<br>
&gt; -=C2=A0 =C2=A0 if (endstrbefore[0] !=3D vertica)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args form=
at: %s&quot;, source);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (!isdigit(endstrbefore[1]))<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;invalid prio_args form=
at: %s&quot;, source);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 *basenum =3D (long long)strtol(&amp;endstrbefore[1], &a=
mp;endstrafter, 10);<br>
&gt; -=C2=A0 =C2=A0 if (check_args_valid(*ionum, *basenum) =3D=3D 0)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char source[MAX_CHAR_SIZE];<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char vertica =3D &#39;|&#39;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *endstrbefore =3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *endstrafter =3D NULL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned int size =3D strlen(args);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((args =3D=3D NULL) || (ionum =3D=3D NULL) || =
(basenum =3D=3D NULL)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;ar=
gs string is NULL&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((size &lt; 1) || (size &gt; MAX_CHAR_SIZE - 1=
)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;ar=
gs string&#39;s size is too long&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0memcpy(source, args, size + 1);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!isdigit(source[0])) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;in=
valid prio_args format: %s&quot;, source);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*ionum =3D (int)strtoul(source, &amp;endstrbefore=
, 10);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (endstrbefore[0] !=3D vertica) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;in=
valid prio_args format: %s&quot;, source);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!isdigit(endstrbefore[1])) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;in=
valid prio_args format: %s&quot;, source);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*basenum =3D (long long)strtol(&amp;endstrbefore[=
1], &amp;endstrafter, 10);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (check_args_valid(*ionum, *basenum) =3D=3D 0) =
{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -long long calc_standard_deviation(long long *path_latency, int size, =
long long avglatency)<br>
&gt; +long long calc_standard_deviation(long long *path_latency, int size,<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0long long avglatency)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 int index;<br>
&gt; -=C2=A0 =C2=A0 long long total =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int index;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long total =3D 0;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 for (index =3D 0; index &lt; size; index++)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 total +=3D (path_latency[index] - avglate=
ncy) * (path_latency[index] - avglatency);<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (index =3D 0; index &lt; size; index++) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total +=3D<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(path_l=
atency[index] - avglatency) * (path_latency[index] -<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0avglatency);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 total /=3D (size-1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0total /=3D (size - 1);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 return (long long)sqrt((double)total);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return (long long)sqrt((double)total);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -int calcPrio(double avglatency, double max_avglatency, double min_avg=
latency, double base_num)<br>
&gt; +int calcPrio(double avglatency, double max_avglatency, double min_avg=
latency,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 double base_num)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 double lavglatency =3D log(avglatency)/log(base_num);<b=
r>
&gt; -=C2=A0 =C2=A0 double lmax_avglatency =3D log(max_avglatency)/log(base=
_n<wbr>um);<br>
&gt; -=C2=A0 =C2=A0 double lmin_avglatency =3D log(min_avglatency)/log(base=
_n<wbr>um);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lavglatency =3D log(avglatency) / log(base=
_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lmax_avglatency =3D log(max_avglatency) / =
log(base_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lmin_avglatency =3D log(min_avglatency) / =
log(base_num);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 if (lavglatency &lt;=3D lmin_avglatency)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (int)(lmax_avglatency + 1.);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (lavglatency &lt;=3D lmin_avglatency)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (int)(lmax_avg=
latency + 1.);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 if (lavglatency &gt; lmax_avglatency)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (lavglatency &gt; lmax_avglatency)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 return (int)(lmax_avglatency - lavglatency + 1.);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return (int)(lmax_avglatency - lavglatency + 1.);=
<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 /* Calc the latency interval corresponding to the average latenc=
y */<br>
&gt;=C2=A0 long long calc_latency_interval(double avglatency, double max_av=
glatency,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 double min_avglatency, double ba=
se_num)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0double min_avglatency, double base_num)<=
br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 double lavglatency =3D log(avglatency)/log(base_num);<b=
r>
&gt; -=C2=A0 =C2=A0 double lmax_avglatency =3D log(max_avglatency)/log(base=
_n<wbr>um);<br>
&gt; -=C2=A0 =C2=A0 double lmin_avglatency =3D log(min_avglatency)/log(base=
_n<wbr>um);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if ((lavglatency &lt;=3D lmin_avglatency)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 || (lavglatency &gt; lmax_avglatency))<br=
>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;/* Invalid value */<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if ((double)((int)lavglatency) =3D=3D lavglatency)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (long long)(avglatency - (avglaten=
cy / base_num));<br>
&gt; -=C2=A0 =C2=A0 else<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (long long)(pow(base_num, (double)=
((int)lavglatency + 1))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - pow(base_num, (double)((i=
nt)lavglatency)));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lavglatency =3D log(avglatency) / log(base=
_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lmax_avglatency =3D log(max_avglatency) / =
log(base_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0double lmin_avglatency =3D log(min_avglatency) / =
log(base_num);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((lavglatency &lt;=3D lmin_avglatency)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|| (lavglatency &gt; lmax_avglatenc=
y))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* Invalid value */<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((double)((int)lavglatency) =3D=3D lavglatency=
)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (long long)(av=
glatency - (avglatency / base_num));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (long long)(po=
w(base_num, (double)((int)lavglatency + 1))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - pow(base_num, (double)((int)la=
vglatency)));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -int getprio (struct path *pp, char *args, unsigned int timeout)<br>
&gt; +int getprio(struct path *pp, char *args, unsigned int timeout)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 int rc, temp;<br>
&gt; -=C2=A0 =C2=A0 int index =3D 0;<br>
&gt; -=C2=A0 =C2=A0 int io_num;<br>
&gt; -=C2=A0 =C2=A0 int base_num;<br>
&gt; -=C2=A0 =C2=A0 long long avglatency;<br>
&gt; -=C2=A0 =C2=A0 long long latency_interval;<br>
&gt; -=C2=A0 =C2=A0 long long standard_deviation;<br>
&gt; -=C2=A0 =C2=A0 long long toldelay =3D 0;<br>
&gt; -=C2=A0 =C2=A0 long long before, after;<br>
&gt; -=C2=A0 =C2=A0 struct timespec tv;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (pp-&gt;fd &lt; 0)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (get_ionum_and_basenum(args, &amp;io_num, &amp;base_=
num) =3D=3D 0)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: get path_latency a=
rgs fail&quot;, pp-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return DEFAULT_PRIORITY;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 memset(path_latency, 0, sizeof(path_latency));<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 temp =3D io_num;<br>
&gt; -=C2=A0 =C2=A0 while (temp-- &gt; 0)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 (void)clock_gettime(CLOCK_MONO<wbr>TONIC,=
 &amp;tv);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 before =3D timeval_to_us(&amp;tv);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (do_readsector0(pp-&gt;fd, timeout) =
=3D=3D 2)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: path=
 down&quot;, pp-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 (void)clock_gettime(CLOCK_MONO<wbr>TONIC,=
 &amp;tv);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 after =3D timeval_to_us(&amp;tv);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 path_latency[index] =3D after - before;<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 toldelay +=3D path_latency[index++];<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 avglatency =3D toldelay/(long long)io_num;<br>
&gt; -=C2=A0 =C2=A0 pp_pl_log(4, &quot;%s: average latency is (%lld us)&quo=
t;, pp-&gt;dev, avglatency);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 if (avglatency &gt; MAX_AVG_LATENCY)<br>
&gt; -=C2=A0 =C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(0, &quot;%s: average latency (%=
lld us) is outside the thresold (%lld us)&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, avglatency, (lo=
ng long)MAX_AVG_LATENCY);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 return DEFAULT_PRIORITY;<br>
&gt; -=C2=A0 =C2=A0 }<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 /* Min average latency and max average latency are cons=
tant, the args base_num<br>
&gt; -=C2=A0 =C2=A0 set can change latency_interval value corresponding to =
avglatency and is not constant.<br>
&gt; -=C2=A0 =C2=A0 Warn the user if latency_interval is smaller than (2 * =
standard_deviation), or equal */<br>
&gt; -=C2=A0 =C2=A0 standard_deviation =3D calc_standard_deviation(path_l<w=
br>atency, index, avglatency);<br>
&gt; -=C2=A0 =C2=A0 latency_interval =3D calc_latency_interval(avglaten<wbr=
>cy, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);<br>
&gt; -=C2=A0 =C2=A0 if ((latency_interval!=3D 0)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;&amp; (latency_interval &lt;=3D (2 *=
 standard_deviation)))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_pl_log(3, &quot;%s: latency interval (=
%lld) according to average latency (%lld us) is smaller than &quot;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;2 * standard deviatio=
n (%lld us), or equal, args base_num (%d) needs to be set bigger value&quot=
;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;dev, latency_interva=
l, avglatency, standard_deviation, base_num);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 rc =3D calcPrio(avglatency, MAX_AVG_LATENCY, MIN_AVG_LA=
TENCY, base_num);<br>
&gt; -=C2=A0 =C2=A0 return rc;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int rc, temp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int index =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int io_num;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int base_num;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long avglatency;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long latency_interval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long standard_deviation;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long toldelay =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0long long before, after;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct timespec tv;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (pp-&gt;fd &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (get_ionum_and_basenum(args, &amp;io_num, &amp=
;base_num) =3D=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0, &quot;%s=
: get path_latency args fail&quot;, pp-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return DEFAULT_PRIORI=
TY;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0memset(path_latency, 0, sizeof(path_latency));<br=
>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0temp =3D io_num;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (temp-- &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(void)clock_gettime(C=
LOCK_MON<wbr>OTONIC, &amp;tv);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0before =3D timeval_to=
_us(&amp;tv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (do_readsector0(pp=
-&gt;fd, timeout) =3D=3D 2) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0pp_pl_log(0, &quot;%s: path down&quot;, pp-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(void)clock_gettime(C=
LOCK_MON<wbr>OTONIC, &amp;tv);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0after =3D timeval_to_=
us(&amp;tv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0path_latency[index] =
=3D after - before;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0toldelay +=3D path_la=
tency[index++];<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0avglatency =3D toldelay / (long long)io_num;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0pp_pl_log(4, &quot;%s: average latency is (%lld u=
s)&quot;, pp-&gt;dev, avglatency);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (avglatency &gt; MAX_AVG_LATENCY) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(0,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&quot;%s: average latency (%lld us) is outside the thresold (=
%lld us)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pp-&gt;dev, avglatency, (long long)MAX_AVG_LATENCY);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return DEFAULT_PRIORI=
TY;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * Min average latency and max average latency ar=
e constant, the args<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * base_num set can change latency_interval value=
 corresponding to<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * avglatency and is not constant.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * Warn the user if latency_interval is smaller t=
han (2 * standard_deviation),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * or equal.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0standard_deviation =3D<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0calc_standard_deviation(path_<wbr>l=
atency, index, avglatency);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0latency_interval =3D<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0calc_latency_interval(avglate<wbr>n=
cy, MAX_AVG_LATENCY, MIN_AVG_LATENCY,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0base_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((latency_interval !=3D 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;&amp; (latency_interval &lt;=
=3D (2 * standard_deviation)))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp_pl_log(3,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&quot;%s: latency interval (%lld) according to average latenc=
y (%lld us) is smaller than &quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&quot;2 * standard deviation (%lld us), or equal, args base_n=
um (%d) needs to be set bigger value&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pp-&gt;dev, latency_interval, avglatency,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0standard_deviation, base_num);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0rc =3D calcPrio(avglatency, MAX_AVG_LATENCY, MIN_=
AVG_LATENCY, base_num);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return rc;<br>
&gt;=C2=A0 }<br>
&gt;<br>
<br>
</blockquote>
</div>
</div>
</blockquote>
<div><br>
</div>
</div></div></div>

</blockquote></div><br></div>

--94eb2c0933a81901940555fbc6dc--


--===============1138902448465869177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1138902448465869177==--
