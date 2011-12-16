From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: how to troubleshoot faulty multipath path?
Date: Fri, 16 Dec 2011 16:49:26 +0100
Message-ID: <4EEB6886.402@UGent.be>
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

I'm running an IBM DS3400 and am seeing a faulty paths:

mail11-ds3400-1 (3600a0b80005a591a0000042b4cac46de) dm-2 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 1:0:0:11 sdd  8:48   active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
   `- 5:0:0:11 sdr  65:16  active undef  running
mail10-ds3400-1 (3600a0b80005a67b60000046a4cac4613) dm-1 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 5:0:0:10 sdq  65:0   active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
   `- 1:0:0:10 sdc  8:32   active undef  running
mail15r-ds3400-1 (3600a0b80005a67b60000046d4cac464f) dm-6 IBM,1726-4xx 
FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 5:0:0:15 sdv  65:80  active faulty running
`-+- policy='round-robin 0' prio=-1 status=active
   `- 1:0:0:15 sdh  8:112  active undef  running


The storage software says those luns are not 'on the preferred path'.

I'm a bit clueless where to look next.

I see on the storage software that other luns are on that controller, so 
it seems to me that controller/path is not the problem.

Where should I look next?  I'm afraid that if I change the ownership it 
will take the lun offline.

Thanks in advance,

Rudy
