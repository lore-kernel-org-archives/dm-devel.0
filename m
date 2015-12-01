From: Alexey Ishchuk <aishchuk@linux.vnet.ibm.com>
Subject: [RFC] Modern device mapper module makes problems for
	dump analysis
Date: Tue, 1 Dec 2015 16:34:53 +0300
Message-ID: <565DA1FD.3010804@linux.vnet.ibm.com>
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Hi,

in the modern device mapper Linux kernel module the data structure 
struct dm_table is declared more than once. One of those declarations is 
the real structure definition and the other are dummy definitions. This 
coding manner makes serious problems for the Linux kernel dump analysis 
with crash utility using custom EPPIC language scripts and even the 
dminfo built-in crash extension does not work with the dumps. The 
problem occurs because the crash utility tries to expose to the EPPIC 
language scripts a dummy structure definition that contains no required 
fields.

I would like to get to know, why do we need more than one struct 
dm_table declarations in the kernel module? Is it possible to improve 
the device mapper kernel module code to have the only one struct 
dm_table declaration to allow kernel dumps to be analyzed using custom 
scripts?

Best regards,
Alexey Ishchuk
