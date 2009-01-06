From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Date: Tue, 6 Jan 2009 03:21:18 +0000
Message-ID: <20090106032118.GC3512@agk.fab.redhat.com>
References: <20081010125159.GK5098@agk.fab.redhat.com>
	<20090105191824.GP5098@agk.fab.redhat.com>
	<alpine.LFD.2.00.0901051843570.3057@localhost.localdomain>
	<91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Cheng Renquan =?utf-8?B?KOeoi+S7u+WFqCk=?= <crquan@gmail.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (=E7=A8=8B=E4=BB=BB=
=E5=85=A8) wrote:
> So now maybe we can add a null macro to module_refcount if
> CONFIG_MODULE_UNLOAD undefined?
=20
Do we even need the test at all?

Alasdair
--=20
agk@redhat.com
