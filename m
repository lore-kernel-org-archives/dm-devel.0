From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?="
	<crquan@gmail.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Date: Tue, 6 Jan 2009 11:32:51 +0800
Message-ID: <91b13c310901051932p1343f9eei1db5534e6e10d238@mail.gmail.com>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
	<alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
	<91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
	<20090106032118.GC3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090106032118.GC3512@agk.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 6, 2009 at 11:21 AM, Alasdair G Kergon <agk@redhat.com> wrote=
:
> On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (=E7=A8=8B=E4=BB=
=BB=E5=85=A8) wrote:
>> So now maybe we can add a null macro to module_refcount if
>> CONFIG_MODULE_UNLOAD undefined?
>
> Do we even need the test at all?

So you mean add "#ifdef CONFIG_MODULE_UNLOAD ..." to dm-target.c? I
can do that, but I really don't know a better solution without
conditional compiling?

>
> Alasdair
> --
> agk@redhat.com

--=20
Cheng Renquan, Shenzhen, China
Eddie Izzard  - "I grew up in Europe, where the history comes from."
