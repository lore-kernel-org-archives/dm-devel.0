From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 05/14] multipathd: use MALLOC and check
 return value in, cli_getprkey func
Date: Fri, 4 Sep 2020 13:25:55 -0500
Message-ID: <20200904182555.GA11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<5edc1c2b-eb21-198b-9880-3be6621496f9@huawei.com>
	<4a51a6797398562b475e3320220112c2cd0d2186.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4a51a6797398562b475e3320220112c2cd0d2186.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, Sep 03, 2020 at 09:13:04PM +0200, Martin Wilck wrote:
> On Wed, 2020-09-02 at 15:18 +0800, lixiaokeng wrote:
> > In cli_getprkey func, we use MALLOC instead of malloc, and check
> > the return value of MALLOC.
> > 
> > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> > Signed-off-by: Linfeilong <linfeilong@huawei.com>
> > ---
> >  multipathd/cli_handlers.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 27e4574f..d345afd3 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -1535,7 +1535,11 @@ cli_getprkey(void * v, char ** reply, int *
> > len, void * data)
> >  	if (!mpp)
> >  		return 1;
> > 
> > -	*reply = malloc(26);
> > +	*reply = MALLOC(26);
> > +	if (!*reply) {
> > +		condlog(0, "malloc *reply failed.");
> > +		return 1;
> > +	}
> 
> MALLOC is not necessary (*reply isn't left uninialized), nor is the
> error message.

What's you objection to the error message? Admittedly there is basically
no chance that malloc(26) would ever actually fail. But when things
fail, having error messages so that we can debug them faster is helpful.

If your objection is that malloc checks are mostly just there for good
form, and so those error messages won't actually help in practice, I
agree. But as a general rule, I think we should print error messages on
things that are unambiguoulsy errors.

-Ben

> 
> Regards,
> Martin
> 
