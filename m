From: "bart brooks" <bart_brooks@hotmail.com>
Subject: SCSI Sense patch
Date: Tue, 05 Sep 2006 13:59:51 +0000
Message-ID: <BAY114-F20C6936AC3F7E04C0C7C429D300@phx.gbl>
References: <1156791189.26413.8.camel@cutter>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1156791189.26413.8.camel@cutter>
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

I have been using for sometime Axboe’s SCSI sense data patches, which make 
available the sense data in the bio end_io path and the dm-mpath’s 
hw_handler. They work very nice.

When will the show up in RHEL 4, in update 5 or later?

Thanks

Bart Brooks
