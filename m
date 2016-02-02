From: Alex Gorbachev <ag@iss-integration.com>
Subject: Re: Target and deduplication?
Date: Mon, 1 Feb 2016 22:51:55 -0500
Message-ID: <CADb94514scHYQBNMxu4rVxZc=Bv7tBRm_02W2yvifKQo55+fiw@mail.gmail.com>
References: <CAKdSmgsZe_dfhN_7R6P7tLfkciv-9dUJKKNj16xeWYXG8aTVVA@mail.gmail.com>
	<20160128085013.GA18023@infradead.org>
	<20160128135654.GA4960@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160128135654.GA4960@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Henrik Goldman <hg@x-formation.com>, dm-devel@redhat.com, target-devel <target-devel@vger.kernel.org>
List-Id: dm-devel.ids

>> On Thu, Jan 28, 2016 at 12:44:25AM +0100, Henrik Goldman wrote:
>> > Hello,
>> >
>> > Has anyone (possibly except purestorage) managed to make target work
>> > with deduplication?
>>
>> The iblock drivers works perfectly fine on top of the dm-dedup driver,
>> which unfortunately still hasn't made it to mainline despite looking
>> rather solid.
>
> The author(s) fell off the face of the earth.  And in testing it fell
> over pretty easily.  So I really have no idea what your view of it
> "looking rather solid" is based on.
> --

If for archival, not for inline dedup, we have had good results with
https://github.com/borgbackup

Regards,
Alex
