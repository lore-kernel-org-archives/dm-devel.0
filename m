From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH RFT/RFC 4/4] add dm-hp-sw hw handler
Date: Sat, 01 Oct 2005 00:01:27 +0200
Message-ID: <1128117687.6536.78.camel@zezette>
References: <1128109342.24395.26.camel@max> <433DA3AB.9010900@redhat.com>
	<1128113524.6536.63.camel@zezette>  <433DB11A.9090001@cs.wisc.edu>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <433DB11A.9090001@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On ven, 2005-09-30 at 16:41 -0500, Mike Christie wrote:
> Christophe Varoqui wrote:
> > On ven, 2005-09-30 at 16:44 -0400, Rob Kenna wrote:
> > 
> >>Is this for HP active/passive support?  Thanks.
> >>
> > 
> > It is : EMA8000, EMA12000, EVA3000, EVA5000
> > EVA4000 , 6000, 8000 don't need no hardware handler (afaik).
> > 
> 
> How does that fit into the storage works (the sw in dm-hp-sw) naming. 
> Should I rename the module and fix the Kconfig?

dm-sstart :
dm-scsi-start :
  - express the actual role of the handler
  - does not discriminate other vendors like FSC using the same trick

dm-assym-hp-sw
  - express clearly the product family

dm-assym-sworks
  - does not use the "hp" branding
    not so bad considering how many corps have controled StorageWorks
    (Digital, Compaq, HP, ...)

I let you decide ... I have no taste for those things, as Alasdair
already noted with my pp_ prefixes :)

Regards,
cvaroqui
