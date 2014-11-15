From: =?GBK?B?xN/UtL2t?= <niyuanjiang@ict.ac.cn>
Subject: why does dm-cache use dm_deferred_entry_inc?
Date: Sat, 15 Nov 2014 16:49:52 +0800 (GMT+08:00)
Message-ID: <b05d91.32d5e.149b2a4ea2b.Coremail.niyuanjiang@ict.ac.cn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6672992100819982541=="
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

--===============6672992100819982541==
Content-Type: multipart/alternative;
	boundary="----=_Part_730670_10545943.1416041392683"

------=_Part_730670_10545943.1416041392683
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 7bit



Hello,

I'm reading the dm-cache code.I notice that before a bio is remapped and sent to the "real" device.the function "dm_deferred_entry_inc" will be invoked.And when a migration initiated ,the function "dm_deferred_set_add_work"  will be invoked to determine whether start the migration immediately.I guess those operation are used to ensure some sort of synchronization.But i'm not sure which kind of synchronization it can ensure and why.

Or my understanding is completely wrong . they are not at all used for synchronization?

Can anyone help me about this question?Thanks,

Yuanjiang Ni

 



------=_Part_730670_10545943.1416041392683
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: 7bit

<p><br><br>Hello,</p><p>I'm reading the dm-cache code.I&nbsp;notice that&nbsp;before a bio is remapped and&nbsp;sent to the "real" device.the function "dm_deferred_entry_inc" will be&nbsp;invoked.And&nbsp;when a&nbsp;migration initiated ,the&nbsp;function "dm_deferred_set_add_work"&nbsp;&nbsp;will be invoked to determine whether start the migration immediately.I guess&nbsp;those operation&nbsp;are used to&nbsp;ensure some&nbsp;sort of synchronization.But i'm not&nbsp;sure which kind of&nbsp;synchronization it can ensure and why.</p><p>Or my understanding is completely wrong&nbsp;. they are not at all used for synchronization?</p><p>Can anyone help me about this question?Thanks,</p><p>Yuanjiang Ni</p><p>&nbsp;</p><span></span><br><br><br>
------=_Part_730670_10545943.1416041392683--


--===============6672992100819982541==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6672992100819982541==--
