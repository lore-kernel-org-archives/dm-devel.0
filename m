From: Miles Taylor <Miles.Taylor@maxim-ic.com>
Subject: mpath_ctl syntax
Date: Fri, 17 Dec 2010 18:44:15 -0600
Message-ID: <FD82D8ED07BC7248BA2BC888CD8736BF07CD607AD5@ITDALEX06.it.maxim-ic.internal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am I correct in assuming that mpath_ctl can remove a single path from an multipath device that consists of four paths?  

If so, would someone let me know what the syntax is or where I can find documentation for mpath_ctl?   I've tried multiple permutations of what mpath_ctl says it wants when run with no arguments without luck.  

I've tried 

mpath_ctl remove map dm-110
mpath_ctl remove map mpath71
mpath_ctl remove path sdz

as well as others

If this is not the correct forum would you please point me in the correct direction?

Thanks.
