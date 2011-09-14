From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd & EMC Clariion CX-4
Date: Wed, 14 Sep 2011 13:39:31 +0200
Message-ID: <4E709273.8000901@suse.de>
References: <21739_1315994330_4E707ADA_21739_7623_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3A@THSONEA01CMS03P.one.grp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <21739_1315994330_4E707ADA_21739_7623_1_EEF700FCD1A35041BF2C750B4EDDCA310138F9C49D3A@THSONEA01CMS03P.one.grp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 09/14/2011 11:58 AM, NEVEU Stephane wrote:
> Hi all,
>
> I'm experiencing problems trying to set up a multipathd config with
> a EMC Clariion CX-4 Storage.
>
> It seems that the CX4 is actually active/passive regarding SPs. My
> server  has QLogic Fiber Cards. My multipath-tools version is 0.4.8.
>
> Here is my multipath.conf :
>
> ##
>
> ## This is a template multipath-tools configuration file
>
> ## Uncomment the lines relevent to your environment
>
> ##
>
> defaults {
>
>                  user_friendly_names   yes
>
> }
>
> blacklist {
>
>                  #devnode "*"
>
>                  devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>
>                  devnode "^hd[a-z][[0-9]*]"
>
>                  devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
>
> }
>
> devices {
>
>                  device {
>
>                                 vendor "DGC "
>
>                                 product "*"
>
That is wrong. The configuration file doesn't allow for regular =

expressions or wildcards. Please use the correct name ('RAID 5') here.
And 'directio' is most certainly wrong here.

What's wrong with the default setting? It should work out of the box =

without configuration file at all ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
