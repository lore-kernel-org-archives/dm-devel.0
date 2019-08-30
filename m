From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
 'broken' and fail BIOs if a member is gone
Date: Fri, 30 Aug 2019 11:47:24 +0100
Message-ID: <5D68FEBC.9060709@youngman.org.uk>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
	<8163258e-839c-e0b8-fc4b-74c94c9dae1d@canonical.com>
	<F0E716F8-76EC-4315-933D-A547B52F1D27@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F0E716F8-76EC-4315-933D-A547B52F1D27@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Song Liu <songliubraving@fb.com>, "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 23/08/19 18:51, Song Liu wrote:
> I guess md_is_broken() should return bool? Otherwise, looks good to me. 

Just an outsider's observation - if the function is actually checking
whether a member is missing maybe it should read

   broken = md_member_is_missing();

That way the function says what it does, and the assignment says what
you're doing with it.

Cheers,
Wol
