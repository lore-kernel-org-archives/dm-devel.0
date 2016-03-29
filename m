From: Nick Fisk <nick@fisk.me.uk>
Subject: Re: [ceph-users] Local SSD cache for ceph on each
	compute node.
Date: Tue, 29 Mar 2016 14:53:11 +0100
Message-ID: <e2c12cad.9Ro.9Gf.hp.1e3JYGxgKj@mailjet.com>
References: <VI1PR05MB16772049FF17DD2D4DE93EDEE08A0@VI1PR05MB1677.eurprd05.prod.outlook.com>
	<1003879409.38672781.1458091493153.JavaMail.zimbra@redhat.com>
	<VI1PR05MB1677B32D621D52ECFBD8C889E08A0@VI1PR05MB1677.eurprd05.prod.outlook.com>
	<1517351774.38675790.1458092531934.JavaMail.zimbra@redhat.com>
	<8C4FE234-AC6A-4F80-84DA-DCB69C58E874@ebay.com>
	<VI1PR05MB1677291EA89E9C02BEE437C2E08A0@VI1PR05MB1677.eurprd05.prod.outlook.com>
	<054DE45B-30E4-44B6-88CE-23FC207FE41E@ebay.com>
	<56F792F6.9050400@redhat.com>
	<DC9C5DB4-43C1-49DB-A37E-F7C6A9D3D172@ebay.com>
	<56FA46C9.6090500@redhat.com>
	<E5E25BC0-A526-4EB8-9EC0-80F6A7734B23@ebay.com>
	<56FA6792.1050005@redhat.com>
	<alpine.DEB.2.11.1603290827510.6473@cpach.fuggernut.com>
	<56FA7DEA.9010005@redhat.com>
	<ce98776b.9Ro.9Gf.cS.1kvo9AAN6V@mailjet.com>
	<56FA859B.5050608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56FA859B.5050608@redhat.com>
Content-Language: en-gb
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Ric Wheeler' <rwheeler@redhat.com>, 'Sage Weil' <sage@newdream.net>
Cc: ceph-users@lists.ceph.com, 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: ceph-users [mailto:ceph-users-bounces@lists.ceph.com] On Behalf Of
> Ric Wheeler
> Sent: 29 March 2016 14:40
> To: Nick Fisk <nick@fisk.me.uk>; 'Sage Weil' <sage@newdream.net>
> Cc: ceph-users@lists.ceph.com; device-mapper development <dm-
> devel@redhat.com>
> Subject: Re: [ceph-users] Local SSD cache for ceph on each compute node.
> 
> On 03/29/2016 04:35 PM, Nick Fisk wrote:
> > One thing I picked up on when looking at dm-cache for doing caching
> > with RBD's is that it wasn't really designed to be used as a writeback
> > cache for new writes, as in how you would expect a traditional
> > writeback cache to work. It seems all the policies are designed around
> > the idea that writes go to cache only if the block is already in the
> > cache (through reads) or its hot enough to promote. Although there did
> > seem to be some tunables to alter this behaviour, posts on the mailing
> > list seemed to suggest this wasn't how it was designed to be used. I'm
> > not sure if this has been addressed since I last looked at it though.
> >
> > Depending on if you are trying to accelerate all writes, or just your
"hot"
> > blocks, this may or may not matter. Even <1GB local caches can make a
> > huge difference to sync writes.
> 
> Hi Nick,
> 
> Some of the caching policies have changed recently as the team has looked
> at different workloads.
> 
> Happy to introduce you to them if you want to discuss offline or post
> comments over on their list: device-mapper development <dm-
> devel@redhat.com>
> 
> thanks!
> 
> Ric

Hi Ric,

Thanks for the heads up, just from a quick flick through I can see there are
now separate read and write promotion thresholds, so I can see just from
that it would be a lot more suitable for what I intended. I might try and
find some time to give it another test.

Nick

> 
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
