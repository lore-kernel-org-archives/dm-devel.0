From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] multipath: add find_multipaths feature.
Date: Thu, 1 Sep 2011 15:43:54 -0500
Message-ID: <20110901204354.GN11793@ether.msp.redhat.com>
References: <20110725185758.GA1368@ether.msp.redhat.com>
	<20110901025518.GD11793@ether.msp.redhat.com>
	<1314861263.14056.89.camel@lapoo.opensvc.com>
	<20110901125720.GF11793@ether.msp.redhat.com>
	<20110901142106.GG11793@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110901142106.GG11793@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 01, 2011 at 09:21:06AM -0500, Benjamin Marzinski wrote:
> 
> although it looks like the systemd folks have made /run a tmpfs
> filesystem, and /var/run a pointer to it (at least in Fedora), so I
> guess I'm not opposed to moving things back to /var/run anymore.
> 

When I wrote this, I had just finished writing an email about how
/var/run being on tmpfs made it o.k. for pidfiles, and my brain had
obviously not switched gears. While I have no problem with pidfiles on
/var/run, storing permanent configuration files on it is obviously not
an option if it is a tmpfs filesystem.

-Ben
