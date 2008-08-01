From: Luke S Crawford <lsc@prgmr.com>
Subject: Re: LVM Snapshot Feature
Date: 01 Aug 2008 10:15:18 -0400
Message-ID: <m3sktoddop.fsf@luke.xen.prgmr.com>
References: <4DE0C34D8B0DA64C9585DC45C36EA03BAB0788@dewdfe1g.wdf.sap.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DE0C34D8B0DA64C9585DC45C36EA03BAB0788@dewdfe1g.wdf.sap.corp>
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
List-Id: dm-devel.ids

"Bombardier, Pascal" <pascal.bombardier@sap.com> writes:
> In your opinion, does it make sense to be able to create non-persistent
> snapshots ?
> In the case of a filesystem backup, a non-persistent snapshot would be a
> snapshot that we agree to lose in case of failure or reboot. If anything
> happens, a server administrator would have to recreate a new snapshot
> and then restart the backup.

Considering the current failure mode when a snapshot becomes 'full' (that
is, when I run out of space to remap changed blocks the snapshot becomes
corrupted) this is the only way I currently feel comfortable using LVM 
snapshots at all, so personally, I think snapshots that did not persist
through reboots would be quite useful.
