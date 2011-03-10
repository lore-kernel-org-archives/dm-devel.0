From: Guillaume Camera <camera.g@gmail.com>
Subject: [MULTIPATH] Help to understand some points
Date: Thu, 10 Mar 2011 17:46:43 +0100
Message-ID: <AANLkTikMNMZ10epfGhRm+fB7BtfBYXyrRE-_9Q-EYd8a@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hello all,

I have some problems to understand some few things with multipaths. If
I'm wrong to send my email here, can you redirect me where I can get
the information ?

I try to use multipath to setup something like that :

I have two iscsi targets, synchronized in activ/activ mode with drbd,
and I get It with iscsi initiator on another server.  These devices
are available under sdb and sdc. I would like to "multipath" those
device under one path, /dev/mapper/mpath0 for example.

Is it possible ?  How can you gather those devices, how to group
chosen device under one group priority ?

Thank you in advance.

Regards,


-- 
Guillaume Camera
