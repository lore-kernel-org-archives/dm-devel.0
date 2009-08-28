From: "Diedrich Ehlerding" <diedrich.ehlerding@ts.fujitsu.com>
Subject: [multipath] meaning of "no_path_retry nn"
Date: Fri, 28 Aug 2009 15:16:17 +0200
Message-ID: <7ujn84$746nl@dgate20u.abg.fsc.net>
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

I would appreciate an explanation of "no_path_retry nn" parameter in 
multipath.conf. Probably I misunderstood it as a number of seconds. 

I am setting up  a software mirror (mdadm) on top of an EMC Clariion 
configuration for desaster protection. The Clariions are recognized by 
multipath properly; it seems to be set up with "no_path_retry 60" 
(according to multipath -t). I had no further settings in 
multipath.conf; this seems to be hardcoded into multipath. 

However, If I disconnect one Clariion, th mirror doesnt break - 
multipath detects that all paths are failed and tells me that it will 
now wait for 60 retries. These 60 retries seem to last very long; 
atfter 5 minutes, it didnt complete. 

Evertyhing works fine if I set up a multipath.conf containing the 
Clariion settings from multipath -t and modify them to 
"no_path_retry fail" and "features 0 fail_if_no_path".  But even if I 
just reduce the default settings to no_path_retry 2 the mirror doesnt 
break - the IOs seem to hang indefinitely (well, I lost patience after 
~5 minutes).

Probably I misunderstood "no_path_retry 60" - does that mean seconds, 
or minutes, or what else? Is anything except "fail" a useful setting in 
mirrored configurations? 

system is a Suse  with multipath-tools-0.4.7-34.43

Thanks 
Diedrich
-- 
Diedrich Ehlerding, Fujitsu Technology Solutions GmbH, R GE TIS N IC2 
Hildesheimer Str 25, D-30880 Laatzen
Fon +49 511 8489-1806, Fax -251806, Mobil +49 173 2464758
Firmenangaben: http://de.ts.fujitsu.com/imprint.html
