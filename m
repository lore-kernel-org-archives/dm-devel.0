From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dm-crypt hard lockup
Date: Sun, 28 Jun 2020 09:50:39 -0700
Message-ID: <f4e57ef4-e0df-d2e6-a00a-074a08f10dbb@acm.org>
References: <fb4877be-4d88-2816-9000-dcc540e8c093@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fb4877be-4d88-2816-9000-dcc540e8c093@intel.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2020-06-26 02:07, Artur Paszkiewicz wrote:
> I'm getting regular lockups which seem to be caused by dm-crypt. I
> reproduced it on vanilla v5.8-rc2, but I started regularly seeing this
> some time ago on openSUSE Tumbleweed kernels. It's easily reproducible
> (every time, after about a minute) when I run "make -j" on the linux
> kernel sources, sometimes it occurs also when doing other IO intensive
> tasks on multiple CPUs. I'm using LVM and ext4 on dm-crypt devices,
> Intel SSDSC2KW010X6 and SSDSC2BA200G3 SSDs.

Since considerable time I'm doing kernel builds (make -j8) on an
openSUSE Tumbleweed system on top of dm-crypt and an NVMe SSD but I have
not yet encountered any kind of lockup. Maybe another driver, e.g. an
I/O scheduler, is responsible for the lockups?

Bart.
