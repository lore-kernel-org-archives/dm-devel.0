From: David Michael <fedora.dm0@gmail.com>
Subject: Making udev aware of dm-init devices
Date: Mon, 4 Nov 2019 10:43:11 -0500
Message-ID: <CAEvUa7nAYkrdsPhmQpV_ChP5Jtnn9oR2Xb=KmBbXJyTZpGUAzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I would like to be able to use a root device configured by
dm-mod.create with an initrd in some scenarios, but it appears that
the default udev rules do not recognize this setup which prevents
systemd from mounting the root file system.  There is a systemd bug
report with a demo script to illustrate what I mean.[1]  Has anyone
here encountered this, or is there a solution already?

Thanks.

David

[1] https://github.com/systemd/systemd/issues/13618#issuecomment-539566330
