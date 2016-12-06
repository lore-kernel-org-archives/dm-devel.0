From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 10/10] set retrigger_tries to 0 for multipath
Date: Tue, 6 Dec 2016 09:22:25 -0600
Message-ID: <20161206152225.GB25309@octiron.msp.redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-11-git-send-email-bmarzins@redhat.com>
	<fbb6b068-fc38-ddd8-831b-98ce65a17954@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fbb6b068-fc38-ddd8-831b-98ce65a17954@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 06, 2016 at 04:11:42PM +0100, Xose Vazquez Perez wrote:
> On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> 
> > Multipathd uses retrigger_tries to give udev more chances to to fill in
> > the uid_attribute, so that the path device is correctly set up in the
> > udev database. However the multipath command can't do this, so it should
> > just immediately give up on udev, and try to get the wwid directly.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipath/main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/multipath/main.c b/multipath/main.c
> > index ee00fdb..06add30 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -521,6 +521,7 @@ main (int argc, char *argv[])
> >  	if (!conf)
> >  		exit(1);
> >  	multipath_conf = conf;
> > +	conf->retrigger_tries = 0;
> >  	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
> >  		switch(arg) {
> >  		case 1: printf("optarg : %s\n",optarg);
> > 
> 
> I don't know how, but this patch(?) is overwriting the default value:

That's because multipath and mutipathd need to do different things.
However, I can change the patch so that 'multipath -t' still reports the
configured value.

-Ben

> 
> libmultipath/defaults.h:#define DEFAULT_RETRIGGER_TRIES 3
> libmultipath/config.c:  conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
> 
> # multipath -t
> defaults {
> [...]
>         retrigger_tries 0
> [...]
> }
> [...]
