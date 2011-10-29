From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Sat, 29 Oct 2011 12:19:13 +0100
Message-ID: <4EABE131.8010706@googlemail.com>
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
List-Id: dm-devel.ids

As part of my livecd data structure dmsetup is used to create a snapshot 
containing xz-compressed root combined with copy-on-write ram-based 
overlay.

The way as I understand it, the ram-based overlay contains only the 
"chunks" of data which is changed. Is there a way - in terms of a tool 
or by any other means - to look at this overlay to see what data has 
been changed exactly?

I have tried, rather naively as it turned out, to mount the ram-based 
overlay but received  "unknown filesystem type 'DM_snapshot_cow'" error 
message, which makes me thing that the data structure is unique somehow 
and private to the device mapper.

One other thing - my dmsetup man page is from 2006 (created some 5 years 
ago) even though I am using the latest device-mapper package (1.02.63 I 
believe) and this man page does not contain any information on dmsetup 
create snapshot format, which is very annoying. Is there an updated 
version of the man page I could look at?
