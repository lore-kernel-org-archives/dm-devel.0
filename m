From: Vivek Shrivastava <viveks@cs.wisc.edu>
Subject: Relationship between Device Mapper and LVM2
Date: Fri, 01 Apr 2005 01:11:51 -0600
Message-ID: <424CF437.1050607__40364.4159938723$1112372711$gmane$org@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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
To: dm@uk.sistina.com, linux-LVM@sistina.com
List-Id: dm-devel.ids

Dear Sir,
        We are trying to do some work on LVM2, by trying to make it more 
dynamic and suitable for virtual machines. We have a very fundamental 
doubt as follows:

Is LVM2 based on top of "device mapper" and uses "device mapper" as the 
underlying layer of support for writing /reading on the disk. Or Device 
mapper is placed between the kernel and the LVM2. Aslo if possible 
please tell us the entry point of kernel into the device mapper.

Any suggestions on this topic will be highly appreciated.

Thanks,
Vivek
