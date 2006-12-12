From: Daryl Fenton <dfenton@ucalgary.ca>
Subject: qla2xxx and lun issue
Date: Tue, 12 Dec 2006 16:46:04 -0700
Message-ID: <457F3F3C.7040106@ucalgary.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

hey,
we have multiple machines running multipath with rhel 4U3 and 4U4 and 
using qla2xxx FC cards that are hooked upto a dell EMC CX700 SAN. When 
we add LUNs to these machines it works fine. When we take them away 
though they seem to see a ghost LUN of 1gb and it's of type LUN Z. These 
cause the machine to hang on boot until you go into single user mode and 
hit ctrl-c on boot up, after that you need to blacklist the mpath to the 
lun that is no longer there. Is there any way to just blacklist all 
things of type LUN Z? I was just wondering if anyone else has had this 
issue/ knows of a fix being built.

thanks
Daryl
