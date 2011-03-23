From: Bart Coninckx <bart.coninckx@telenet.be>
Subject: difference in running multipathd in console versus cron
Date: Wed, 23 Mar 2011 11:27:23 +0100
Message-ID: <201103231127.23386.bart.coninckx@telenet.be>
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

Hi all,

I've written backup scripts where for a snapshot LV on a iSCSI target 
dynamically an iSCSI LUN and according multipath devices are created. To 
properly clean them up and create them, multipathd is restarted quite a fiew 
times in the script. 
When doing this manually this works very well, and you see the multipath 
devices being created and disappear again.
Running the same from cron, leads to a lot times where the devices are not 
cleaned up, preventing them to be created again for the second run, which then 
fails.
I seem to have messages like "backup_DomU: map in use". 

This is in SLES11SP1 with multipath-tools-0.4.8-40.25.1.

What could I do to get this running properly from cron as well?

Thank you,



B.
