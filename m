From: Drew Hastings <dhastings@crucialwebhost.com>
Subject: Thin provisioning bug in dm-thin
Date: Mon, 4 May 2020 11:54:33 -0700
Message-ID: <CAN-y+ELN7GW5hiOQcK7nTe-_A9XdJExQUEuy7MmiJhzsZTf0+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2513565294338581763=="
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

--===============2513565294338581763==
Content-Type: multipart/alternative; boundary="0000000000006d9b2d05a4d7107d"

--0000000000006d9b2d05a4d7107d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

In process_create_snap_mesg, when dm_thinner_pool_create_snap fails, the
DMWARN is for ARGV[1] and ARGV[2], but should be for 0 and 1.

--0000000000006d9b2d05a4d7107d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">In=C2=A0process_create_snap_mesg, when dm_thinner_pool_cre=
ate_snap fails, the DMWARN is for ARGV[1] and ARGV[2], but should be for 0 =
and 1.<br></div>

--0000000000006d9b2d05a4d7107d--

--===============2513565294338581763==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2513565294338581763==--
