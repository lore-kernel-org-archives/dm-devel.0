From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH v2 1/2] md raid0/linear: Introduce new array
	state 'broken'
Date: Mon, 19 Aug 2019 11:10:56 -0700
Message-ID: <CAPhsuW7aGze5p9DgNAe=KakJGXTNqRZpNCtvi8nKxzS2MPXrNQ@mail.gmail.com>
References: <20190816134059.29751-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190816134059.29751-1-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On Fri, Aug 16, 2019 at 6:41 AM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> Currently if md raid0/linear array gets one or more members removed while
> being mounted, kernel keeps showing state 'clean' in the 'array_state'
> sysfs attribute. Despite udev signaling the member device is gone, 'mdadm'
> cannot issue the STOP_ARRAY ioctl successfully, given the array is mounted.
>
> Nothing else hints that something is wrong (except that the removed devices
> don't show properly in the output of 'mdadm detail' command). There is no
> other property to be checked, and if user is not performing reads/writes
> to the array, even kernel log is quiet and doesn't give a clue about the
> missing member.
>
> This patch changes this behavior; when 'array_state' is read we introduce
> a non-expensive check (only for raid0/md-linear) that relies in the
> comparison of the total number of disks when array was assembled with
> gendisk flags of those devices to validate if all members are available
> and functional. A new array state 'broken' was added: it mimics the state
> 'clean' in every aspect, being useful only to distinguish if such array
> has some member missing. Also, we show a rate-limited warning in kernel
> log in such case.
>
> This patch has no proper functional change other than adding the
> 'clean'-like state; it was tested with ext4 and xfs filesystems. It
> requires a 'mdadm' counterpart to handle the 'broken' state.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

If we merge this with the MD_BROKEN patch, would the code look simpler?

Thanks,
Song
