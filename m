From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 07/15] libmultipath: fix sgio_get_vpd looping
Date: Mon, 20 Jan 2020 10:59:54 -0600
Message-ID: <20200120165954.GT30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-8-git-send-email-bmarzins@redhat.com>
	<42675e7de2ed4c56762438e2cae803da8de9118e.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42675e7de2ed4c56762438e2cae803da8de9118e.camel@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 17, 2020 at 05:27:00PM +0100, Martin Wilck wrote:
> On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> 
> > diff --git a/tests/vpd.c b/tests/vpd.c
> > index d9f80eaa..4dbce010 100644
> > --- a/tests/vpd.c
> > +++ b/tests/vpd.c
> > @@ -306,7 +306,7 @@ static int create_vpd83(unsigned char *buf,
> > size_t bufsiz, const char *id,
> >  	default:
> >  		break;
> >  	}
> > -	put_unaligned_be16(n, buf + 2);
> > +	put_unaligned_be16(bufsiz, buf + 2);
> >  	return n + 4;
> >  }
> 
> I can see that you are trying to create a VPD with a certain given
> length. But this way you intentionally create a VPD that doesn't
> conform to the spec (offset 2 should contain the real length of the
> designator list, not some arbitrary value). This is dangerous, in the
> future someone may copy this code thinking that it creates a valid
> VPD. At least you should add a big fat comment. Better even, you
> should leave out this hunk and override the length value in the
> actual test (make_test_vpd_eui) if (sml == 1) (and also add a comment).

Sure.

-Ben

> 
> Regards
> Martin
> 
