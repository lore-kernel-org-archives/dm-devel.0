From: urgrue <urgrue@bulbous.org>
Subject: SAN failover question
Date: Sun, 01 May 2011 23:01:17 +0200
Message-ID: <4DBDCA1D.3070500@bulbous.org>
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

I've tried all around to find a good solution for my conundrum, without 
much luck.

The point is, multipath works nice. Until a bigger disaster comes along, 
e.g. san or datacenter failure. Of course like most big environments you 
have a synchronous replica of your SAN. But you have to "do stuff" to 
get Linux to take that new LUN and get back to work. A reboot, or san 
rescans, forcibly removing disks and so forth. It's not very pretty.

So my question is, is there any way to get multipath to treat both the 
active lun and it's passive replica (usually in readonly or offline 
state) as one and the same disk? The goal being, if your SAN fails, you 
merely have to activate your DR replica, and multipath would pick it up 
and all's well (except for the 30 sec to a few mins of I/O hanging until 
the DR was online). In essence, you'd have four paths to a LUN - 2 to 
the active one, 2 to the passive one, which is a different LUN 
technically speaking (different serials, WWNs, etc), but an identical 
synchronous replica (identical data, identical state, identical PVID, etc).
