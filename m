From: "=?gb2312?B?y87V8buq?=" <songzhh81@163.com>
Subject: reboot problem
Date: Mon, 30 Oct 2006 10:01:56 +0800
Message-ID: <33865.4399537065$1162177165@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all:
	I'm a beginner to Device Mapper, now I have a problem perhaps stupid.=20
	However, I have made a mapped device named "v1" with table "t1", then I =
made a mapped device named "v2" with table "t2" using "v1" as the targed =
device, and mount "/dev/mapper/v2" at "/mnt/vd".=20
	Now I hope that after reboot there are still "v1","v2" and "v2" will be =
still mounted at "/mnt/vd". How should I do for these? Thanks!

=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1Song Zhenhua
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1songzhh81@163.com
=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A1=A12006-10-30
