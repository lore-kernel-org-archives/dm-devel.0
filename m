From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: devmap_name
Date: Mon, 21 Feb 2005 00:53:20 +0100
Message-ID: <421922F0.9010309@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

would you be interested in merging devmap_name functionnality in dmsetup ?
For background, "devmap_name $major $minor" throw back the associated 
devmap name.

I can code up a patch to do the same with "dmsetup ls [-j|--major 
<major>] [-m|--minor <minor>]" ...

Interested ?

Regards,
cvaroqui
