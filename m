From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: RHEL 5.4 multipath doesn't handle virtio block
	devices
Date: Tue, 30 Mar 2010 14:07:02 +0900
Message-ID: <4BB186F6.1050402@ct.jp.nec.com>
References: <20100330121606.54b4a50c@martins.ozlabs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100330121606.54b4a50c@martins.ozlabs.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Schwenke <martin@meltin.net>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Martin,

On 2010/03/30 10:16 +0900, Martin Schwenke wrote:
> multipath in RHEL 5.4 doesn't handle virtio block devices.  It excludes
> them because they use a sysfs bus that is not recognised.
> 
> Here's a patch that seems to fix this:

Why do you want to use dm-multipath on virtio block devices?

Thanks,
Kiyoshi Ueda
