From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH v3 1/2] md raid0/linear: Mark array as
 'broken' and fail BIOs if a member is gone
Date: Tue, 3 Sep 2019 16:53:20 -0300
Message-ID: <8a55b0b6-25a9-d76b-1a6a-8aaed8bde8a7@canonical.com>
References: <20190822161318.26236-1-gpiccoli@canonical.com>
	<73C4747E-7A9E-4833-8393-B6A06C935DBE@fb.com>
	<8163258e-839c-e0b8-fc4b-74c94c9dae1d@canonical.com>
	<F0E716F8-76EC-4315-933D-A547B52F1D27@fb.com>
	<5D68FEBC.9060709@youngman.org.uk>
	<CAHD1Q_ypdBKhYRVLrg_kf4L8LdXk8rgiiSQjtmoC=jyRv5M5jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHD1Q_ypdBKhYRVLrg_kf4L8LdXk8rgiiSQjtmoC=jyRv5M5jQ@mail.gmail.com>
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
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 30/08/2019 08:25, Guilherme Piccoli wrote:
> Thanks a lot for all the suggestions Song, Neil and Wol - I'll
> implement them and resubmit
> (hopefully) Monday.
> 
> Cheers,
> 
> 
> Guilherme
> 

V4 sent:
https://lore.kernel.org/linux-block/20190903194901.13524-1-gpiccoli@canonical.com/T/#t

Wols, in order to reduce code size and for clarity, I've kept the helper
as "is_mddev_broken()" - thanks for the suggestion anyway!
Cheers,


Guilherme
