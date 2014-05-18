From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Status of Linux LVM thin provisioning
Date: Mon, 19 May 2014 00:46:49 +0200
Message-ID: <CAAOsTSk_wy5snVhQM_8k4fyk5KpnYMYn317+OzkgX6CSoA0K7A@mail.gmail.com>
Reply-To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
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

Hello there,

I am editor in chief of leading Slovak IT news server DSL.sk and I am
preparing material for our future article about Linux LVM. We are
creating production data storage system and will report experience
with that.

What I am trying to find out right now is what is exact status of LVM
thin provisioning. There is warning in
https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.txt
that it is very much still in experimental state and not recommended
for production, but the text seems little outdated. So what is exact
status and what versions of kernel / tools are needed? (We are
currenly using Debian stable but with kernel, LVM and thin
provisioning tools from Debian testing, so kernel 3.13.10-1, lvm2
2.02.104(2) (2013-11-13) and thin-provisioning-tools 0.2.8-1.)

Thanks.

Best regards,

Patrik Horn=EDk
=B9=E9fredaktor www.DSL.sk
Tel.: +421 905 385 666
Email: patrik@dsl.sk
