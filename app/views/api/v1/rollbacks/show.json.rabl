collection @rollback_jobs

attributes :jid, :enqueued_at

node(:rollback_to) { |rollback_job|
  rollback_job.args.first
}

node(:redownload) { |rollback_job|
  !!rollback_job.args.last
}
