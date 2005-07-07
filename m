From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Problem setting up RAID0 Array on Intel ICH7 fake-RAID.
Date: Thu, 7 Jul 2005 15:55:02 +0200
Message-ID: <20050707135502.GA5285@redhat.com>
References: <42CC4644.8050306@gmail.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <42CC4644.8050306@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: hjm@redhat.com
List-Id: dm-devel.ids


Chandler,

please send me the files "dmraid -rD" writes (*.dat, *.size, *.offset)
in a bzip2'ed tarball named isw-Chandler_Garruth.tar.bz2 for
investigation.

Regards,
Heinz

On Wed, Jul 06, 2005 at 04:59:48PM -0400, Chandler Carruth wrote:
> Hello,
> 
> I am attempting to install Gentoo Linux on a box with a RAID0 Array.
> This is a brand new box, with Intel's ICH7 chipset, and accompanying
> fake-RAID chip. The RAID array works in Windows, but despite all my
> attempts, I cannot get it working in Linux. I am now using a LiveCD
> designed specifically to run on boxes with fake-RAID arrays. The various
> software versions are:
> 
> * Grub 0.96
> * device-mapper version 1.00.19
> * dmraid version 1.0.0.rc6
> 
> This is the most recent version I have been able to find. I am
> attempting to compile a binary of dmraid version 1.0.0.rc8, but I am
> doubtful about this solving the problem. Any ideas would be welcome. =]
> 
> # dmraid --debug --verbose -ay
> DEBUG: _find_set: searching isw_bhibhdiifc
> DEBUG: _find_set: not found isw_bhibhdiifc
> ERROR: isw: volume ARRAY is broken
> DEBUG: _find_set: searching isw_bhibhdiifc
> DEBUG: _find_set: found isw_bhibhdiifc
> ERROR: isw: volume ARRAY is broken
> DEBUG : set status of set "isw_bhibhdiifc" to 16
> INFO: Activating GROUP RAID set "isw_bhibhdiifc"
> DEBUG: freeing devices of RAID set "isw_bhibhdiifc"
> DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"
> DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"
> 
> Please, any idea as to how to setup this RAID array?
> 
> -Chandler Carruth



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
