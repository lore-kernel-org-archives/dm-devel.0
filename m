From: gistolero@gmx.de
Subject: fields in "dmsetup status"
Date: Tue, 8 Nov 2005 19:14:24 +0100 (MET)
Message-ID: <1653.1131473664@www93.gmx.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

I would like to know the meaning of the different "dmsetup status" fields:

# dmsetup status
yellow: 0 314572800 multipath 1 0 0 3 1 E 0 1 0 8:64 A 0 E 0 1 0 8:176 F ...

"yellow" = lun alias
"0 314572800" = device length
"multipath" = target
"8:64 A"  = device 8:64 is acitve
"8:176 F" = device 8:x failed
"E" seems to be a placeholder for path_selector.
Is that right?

It would be very nice if someone could explain all fields. I know that
christophe discribes "dmsetup table" on his homepage, but I couldn't find
this for "status".

Thanks,
Simon




-- 
Telefonieren Sie schon oder sparen Sie noch?
NEU: GMX Phone_Flat http://www.gmx.net/de/go/telefonie
