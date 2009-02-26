From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: multipathd segfault and error calling out
Date: Wed, 25 Feb 2009 22:04:01 -0500
Message-ID: <20090226030401.GB6700@mars.virtualiron.com>
References: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
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

On Wed, Feb 25, 2009 at 09:07:44PM -0500, John A. Sullivan III wrote:
> Hello, all.  I am running on kernel 2.6.27 on CentOS 5.2 with VServer
> and device-mapper-multipath-0.4.7-17.el5.  I have a custom
> mpath_prio_ssi script which takes the device name (e.g., sdaa), pulls
> out the path from /etc/disk/by-path and then echos a priority based upon
> a lookup table.  It works perfectly fine from the command line.
> multipath -ll shows the priorities assigned perfectly and exactly the
> right paths are active.
> 
> However, when I start multipathd, it all goes down the tubes.  The paths
> disappear and /var/log/messages is filled with:
> Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdh

Keep in mind that the environment you have when multipathd calls is quite
limited. I believe there is no PATH set, nor any other "normal" values.

Make sure your code uses absolute paths. So "/bin/grep" ,"/bin/cut", etc..
