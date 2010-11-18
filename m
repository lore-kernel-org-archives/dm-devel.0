From: =?ISO-8859-1?Q?Jonas_Bj=F6rklund?= <jonas@bjorklund.cn>
Subject: Split load balanced paths into two groups
Date: Thu, 18 Nov 2010 09:03:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1011180859480.5714@crisp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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

Hello,

Is it possible to split load balanced paths into two groups?

mpath3 (222df000155433964) dm-2 Brand,Model
[size=3.6T][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
  \_ 10:0:0:21 sde 8:64  [active][undef]
  \_ 11:0:0:21 sdf 8:80  [active][undef]
  \_ 12:0:0:21 sdh 8:112 [active][undef]
  \_ 13:0:0:21 sdj 8:144 [active][undef]

I would like to have two failover groups. And then load balance between two paths in each group.

Is that possible?

/Jonas
