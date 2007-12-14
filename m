From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Black listing CLARiiON "LUNZ"?
Date: Fri, 14 Dec 2007 13:44:36 -0600
Message-ID: <20071214194436.GE25939@ether.msp.redhat.com>
References: <D364D39DAD21D444BAE2C70919B62809086CD7BC@CORPUSMX40A.corp.emc.com>
	<940B4FF1F5958E4F96FC83C055A2F2611B8E3A@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8E3A@exch-2003.incipient.waltham>
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

On Mon, Dec 10, 2007 at 10:47:43AM -0500, Paul Cote wrote:
> 
>    Hi Wayne;
> 
>    We're currently locked in with RHEL 4 / Update 4 (2.6.9-42.ELsmp) with
>    multipath tools V4.7.
> 
>    I'm trying to make a play for a later release... but certainly would be
>    quite helpful knowing which one has the fix!
> 
>    Much appreciated.
> 
>    Paul

Since backporting the product_blacklist changes to RHEL4 was too
invasive, RHEL4 has it's own method of blacklisting certain products.
It works largely the same as product_blacklist.  Here is the
documentation from
/usr/shar/doc/device-mapper-multipath-0.4.5/multipath.conf.annotated

#
# name    : bl_product
# scope   : multipath & multipathd
# desc    : a regular expression used to blacklist devices
#           by vendor/product. NOTE For a device to get
#           blacklisted, the vendor, product, and bl_product
#           strings must all match, not just the vendor and
#           bl_product strings as in the upstream version.
# default : (null)

Also, have you tried not including a devices section, and simply using
the compiled in default?

What version of the device-mapper-multipath package are you using?

Thanks.

-Ben
