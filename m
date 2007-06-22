From: "Marcus Minzenmay" <Marcus.Minzenmay@eumetsat.int>
Subject: Problem with lvm - mapping after <= 1s power breakdown ->
	incorrect mapping.
Date: Fri, 22 Jun 2007 11:03:34 +0200
Message-ID: <467BAC81.C2D2.0099.0@eumetsat.int>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

After a very short power breakdown I've got a problem with one of the
(lvm2/reiser) filesystems:

Mounting the /dev/mapper/xxx - device manually for a check it obviously
points to a filesystem which is incorrect and mounted already.
How van this get corrected ?

Regards

...

Marcus Minzenmay
UNIX Systems Engineer
EUMETSAT
Am Kavalleriesand, 31
64295, Darmstadt, Germany
Tel : +49 6151 807-7358 or 0172-1479403
EMail: marcus.minzenmay@eumetsat.int 
iNet : http://www.eumetsat.int 
