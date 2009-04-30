From: "Diedrich Ehlerding" <diedrich.ehlerding@ts.fujitsu.com>
Subject: multipath: expected results of configuring
	"no_path_retry"?
Date: Thu, 30 Apr 2009 10:47:04 +0200
Message-ID: <7oranp$22o15k@dgate10u.abg.fsc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <dm-devel-bounces@redhat.com>
Content-description: Mail message body
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

I have a question concerning the expected behavior of dm_multipath 
connected to an EMC Clariion array. Different versions of multipath 
give different results when I disconnect all pathes to the storage. 

I have one server (SuSE SLES10 SP2, 2.6.16.60-0.3, multipath-tools 
0.4.7-34.43) and another one (SLES 11,  2.6.27.19-5-default, 0.4.8-
40.1). Both versions recognize the Clariion without further setting in 
multipath.conf. The settings for the Clariion in multipath -t seem to 
be the same (especially queue_if_no_path + no_path_retry 60)

Trying to setup a software mirror on top, i.e. trying to mirror the 
data into a second box, I observed the follwoing diffenrent behavior 
between these two versions: 

- on the SLES10 machine, disconnecting the disk in one Clariion results 
in IO error, the mirror breaks up, and the use IO continues on the 
surviving part of the mirror. This is the behavior which I want, and 
which I expected, and this was my understanding of "no_path_retry" - 
retry some times, then terminate IO.  

- on the SLES11 machine, the same attempt makes IO hang infinitely. The 
messages display that all pathes fail, and then "Entering recovery 
mode: max_retries=60" - but then, nothing happens; IOs hang.

I tried to modify no_path_retry=1 in multipath.conf, and according to 
multipath -t, this setting is accepted - but again, the messages say 
"Retry=60"; i.e. this setting seems to be hardcoded into dm_emc.

It is, however, possible to set "features 0" in multipath.conf; now it 
seems to work as desired - i.e. with this setting, IO doesnt hang, but 
is terminated with an IO error when I disconnect the Lun. 

My question is: which behaviour SHOULD I expect - is the SLES10 
behavior correct (retry 60 times, and then create an error); or is the 
SLES11 behavor correct (wait infinitely), if I use the default settings 
for a Clariion?

TIA
D. 
