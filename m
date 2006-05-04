From: Stephen Howell <showell@bigpond.net.au>
Subject: dm-striped device sizes must be multiple of chunk-size
Date: Thu, 04 May 2006 21:52:17 +1000
Message-ID: <1146743537.3583.2.camel@localhost>
References: <1146737507.3650.4.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1146737507.3650.4.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I thought I might also add to my comment of a few hours ago that I have
just compiled the 2.6.15 kernel and have no problem with my dm-stripe
drives under this kernel either. So I appear to be having the same
problem as Joe pointed out.

SH.

On Thu, 2006-05-04 at 20:11 +1000, Stephen Howell wrote:
> I have been reading the post at 
> http://www.archivesat.com/RedHat_device-mapper_development/thread353566.htm
> 
> I also have this problem
> 
> dmraid -s
> *** Active Set
> name   : nvidia_egiafbgb
> size   : 1562845532
> stride : 128
> type   : stripe
> status : ok
> subsets: 0
> devs   : 2
> spares : 0
> 
> dmraid -r
> /dev/sdb: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,
> data@ 0
> /dev/sdc: nvidia, "nvidia_egiafbgb", stripe, ok, 781422766 sectors,
> data@ 0
> 
> and get the dm-stripe error listed in the subject above.
> 
> This occurs under 2.6.16 but not under 2.6.14.
> 
> Thought I might add some more data to Joe's comments.
> 
> Stephen Howell
> Melbourne Australia
