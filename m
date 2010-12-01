From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: ioctl HDIO_GETGEO to device mapper devpath
Date: Wed, 01 Dec 2010 09:58:46 +0100
Message-ID: <1291193926.13116.0.camel@zezette>
References: <AANLkTikBJzQM7gPPo-Wj1-2cfUqzUDa31W9gw=zZGwO4@mail.gmail.com>
	<4CF4A8D7.1020802@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CF4A8D7.1020802@suse.de>
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

On mar., 2010-11-30 at 08:33 +0100, Hannes Reinecke wrote:
> On 10/14/2010 11:40 AM, Santosh Sarangi wrote:
> > Hi,
> > I have a linux  mapper device on the host, I would like to get the start
> > offset.
> > I get this by the following ioctl . Although the call succeeds but it sets
> > the hd_geometry_rec to "0"
> > 
> > I checked through gdb , the ioctl call suceeds ,but sets all the field of
> > hd_geometry to "0"
> > 
> Yep. Device-mapper device are able to report the geometry, but you
> have to set it first :-)
> 
> The attached patch should fix this.
> 
Applied.
Thanks.
