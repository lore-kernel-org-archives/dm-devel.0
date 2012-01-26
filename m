From: Siddharth Choudhuri <sid.kernel@gmail.com>
Subject: Receiving device failure/removal notification within a
	dm-target
Date: Thu, 26 Jan 2012 09:30:08 -0800
Message-ID: <CAHxYQ-U_bqyN76Sos9wUbtN10W6X0kc-PagqvpUT-f1+48zQXg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6697774365938644855=="
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

--===============6697774365938644855==
Content-Type: multipart/alternative; boundary=f46d040168394ad19104b771bbfb

--f46d040168394ad19104b771bbfb
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I want to write a clean up function in a device mapper target if the
underlying block device fails or if it is removed. This is similar to, for
example, having a register_reboot_notifier() inside a dm target so that the
target can take appropriate action on a system reboot.

What would be the best way to handle this ? Should I look at the multi path
code for any hints ? Appreciate any pointers to this.

Thanks,
-Sid

--f46d040168394ad19104b771bbfb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<div><br></div><div>I want to write a clean up function in a device mapp=
er target if the underlying block device fails or if it is removed. This is=
 similar to, for example, having a register_reboot_notifier() inside a dm t=
arget so that the target can take appropriate action on a system reboot.</d=
iv>
<div><br></div><div>What would be the best way to handle this ? Should I lo=
ok at the multi path code for any hints ? Appreciate any pointers to this.<=
/div><div><br></div><div>Thanks,</div><div>-Sid</div><div><br></div><div>
<br></div><div><br></div>

--f46d040168394ad19104b771bbfb--


--===============6697774365938644855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6697774365938644855==--
