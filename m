From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 14:51:34 +0200
Message-ID: <CALLzPKbm0NuEFpt9GyaZnA_jVmbN-kxdrtV_XyVD5e_Auu+02w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1937220647682779683=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--===============1937220647682779683==
Content-Type: multipart/alternative; boundary=e89a8ff24ca129a59b04b6e106c6

--e89a8ff24ca129a59b04b6e106c6
Content-Type: text/plain; charset=UTF-8

Hi,

I rebased on the stop of latest mainline tree and now dmsetup fails...
It says: "Failed to create notification semaphore: Function not
implemented".
I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...

Any ideas?

- Dmitry

--e89a8ff24ca129a59b04b6e106c6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<div><br></div><div>I rebased on the stop of latest mainline tree and no=
w dmsetup fails...</div><div>It says: &quot;Failed to create notification s=
emaphore: Function not implemented&quot;.</div><div>I run strace and saw th=
at dmsetup uses &quot;semget&quot; which returns -ENOSYS...</div>
<div><br></div><div>Any ideas?</div><div><br></div><div>- Dmitry</div><div>=
<br></div>

--e89a8ff24ca129a59b04b6e106c6--


--===============1937220647682779683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1937220647682779683==--
