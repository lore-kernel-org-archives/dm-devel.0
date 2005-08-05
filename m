From: Andrew Morton <akpm@osdl.org>
Subject: Re: File corruption on LVM2 on top of software RAID1
Date: Thu, 4 Aug 2005 20:01:39 -0700
Message-ID: <20050804200139.33df1b18.akpm@osdl.org>
References: <45138.213.188.237.106.1123086677.squirrel@localhost>
	<20050804195853.0866ade9.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050804195853.0866ade9.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: simon.matter@invoca.ch, linux-kernel@vger.kernel.org, kernel-maint@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Andrew Morton <akpm@osdl.org> wrote:
>
> There's one fix against 2.6.12.3 which is needed, but 2.6.9 didn't have the
>  bug which this fix addresses.

aargh, I see that it did fix it.

Don't blame me.  Blame people who screw up list threading by reading a
mail->news gateway and hitting "reply".
