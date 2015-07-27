From: David Binderman <dcb314@hotmail.com>
Subject: linux-4.2-rc4/drivers/md/dm-cache-policy-smq.c:1689: bad
	if test ?
Date: Mon, 27 Jul 2015 07:00:41 +0000
Message-ID: <DUB128-W57EEA6D50E9781025705219C8E0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello there,

[linux-4.2-rc4/drivers/md/dm-cache-policy-smq.c:1689]: (warning) Logical co=
njunction always evaluates to false: !EXPR && EXPR.

Source code is

=A0 if (!mq->cache_hit_bits && mq->cache_hit_bits) {

Maybe

=A0 if (!mq->cache_hit_bits) {

was intended.


Regards

David Binderman


 		 	   		  =
