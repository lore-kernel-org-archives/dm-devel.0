From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [RFC PATCH v2 3/3] libmultipath: change log level
 for null uid_attribute
Date: Thu, 24 Sep 2020 19:03:54 +0000
Message-ID: <a8845e2c457c9817bb3ed315a81b3d3d76348308.camel@suse.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
	<1600923569-17412-4-git-send-email-bmarzins@redhat.com>
	<62ced86c81b139e6461fe0dc14207606548a652a.camel@suse.com>
	<20200924162055.GF11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924162055.GF11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
Content-ID: <52E1FF8B2FD10E40A98EDC27BF610344@eurprd04.prod.outlook.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-09-24 at 11:20 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 08:06:41AM +0000, Martin Wilck wrote:
> > On Wed, 2020-09-23 at 23:59 -0500, Benjamin Marzinski wrote:
> > > 
> > > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > > index f650534f..435f2639 100644
> > > --- a/libmultipath/discovery.c
> > > +++ b/libmultipath/discovery.c
> > > @@ -2091,7 +2091,8 @@ get_uid (struct path * pp, int path_state,
> > > struct udev_device *udev,
> > >  		}
> > >  		if ((!udev_available || (len <= 0 && allow_fallback))
> > >  		    && has_uid_fallback(pp)) {
> > > -			used_fallback = 1;
> > > +			if (udev_available || !(udev && pp-
> > > > uid_attribute))
> > > +				used_fallback = 1;
> > >  			len = uid_fallback(pp, path_state, &origin);
> > >  		}
> > >  	}
> > 
> > Uff, this logic was convoluted anyway, now it's even harder to
> > grasp.
> > IIUC, if !udev, used_fallback will be set to 1, even if 
> > pp->uid_attribute is the empty string. Is that intended?
> > To make this easier to read, I'd suggest something like this:
> 
> My though was that not having a udev device is an unexpected
> situation,
> and so we should continue to log the message at an increased logging
> level.  If you're against that, it's not that important. I can
> certainly
> go with your code logic, or "if (!udev || !empty_uid_attr)" if you
> think
> it's reasonable to log at an increased level whenever the udev_device
> is
> NULL, even if the device was configured to ignore the udev database

My main concern was not the !udev case, nor the logging. It was just
that my brain choked on the complex boolean expression. My suggestion
was intended to make it somewhat easier to grok, that's all.

Cheers,
Martin
